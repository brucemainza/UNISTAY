import bcrypt from 'bcryptjs';
import cors from 'cors';
import 'dotenv/config';
import express from 'express';
import jwt from 'jsonwebtoken';
import { customAlphabet } from 'nanoid';

const app = express();
const port = Number(process.env.PORT || 4000);
const jwtSecret = process.env.JWT_SECRET || 'dev-only-change-this-secret';
const jwtExpiresIn = process.env.JWT_EXPIRES_IN || '7d';
const lencoBaseUrl = process.env.LENCO_BASE_URL || 'https://api.lenco.co/access/v2';
const lencoSecretKey = process.env.LENCO_SECRET_KEY || '';
const lencoMock = process.env.LENCO_MOCK !== 'false' || !lencoSecretKey;
const randomRef = customAlphabet('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', 10);

const users = new Map();
const payments = new Map();

const allowedOrigins = (process.env.CORS_ORIGINS || '')
  .split(',')
  .map((origin) => origin.trim())
  .filter(Boolean);

app.use(
  cors({
    origin(origin, callback) {
      if (!origin || allowedOrigins.length === 0 || allowedOrigins.includes(origin)) {
        callback(null, true);
        return;
      }
      callback(new Error('Origin not allowed by CORS'));
    },
  }),
);
app.use(express.json());

function signUser(user) {
  return jwt.sign(
    {
      sub: user.id,
      phone: user.phone,
      role: user.role,
      fullName: user.fullName,
    },
    jwtSecret,
    { expiresIn: jwtExpiresIn },
  );
}

function publicUser(user) {
  return {
    id: user.id,
    fullName: user.fullName,
    phone: user.phone,
    email: user.email,
    role: user.role,
  };
}

function authRequired(req, res, next) {
  const header = req.get('authorization') || '';
  const token = header.startsWith('Bearer ') ? header.slice(7) : '';

  if (token === 'dev-student-token' && process.env.NODE_ENV !== 'production') {
    req.user = {
      id: 'dev-student',
      fullName: 'Bruce Mainza',
      phone: '0971111111',
      role: 'student',
    };
    next();
    return;
  }

  try {
    req.user = jwt.verify(token, jwtSecret);
    next();
  } catch {
    res.status(401).json({ status: false, message: 'Unauthorized' });
  }
}

function createReference() {
  return `US_${Date.now()}_${randomRef()}`;
}

function normalizeAmount(amount) {
  const parsed = Number(amount);
  if (!Number.isFinite(parsed) || parsed <= 0) {
    return null;
  }
  return Number(parsed.toFixed(2));
}

async function callLenco(path, options = {}) {
  const response = await fetch(`${lencoBaseUrl}${path}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${lencoSecretKey}`,
      ...(options.headers || {}),
    },
  });
  const payload = await response.json().catch(() => ({
    status: false,
    message: 'Invalid response from Lenco',
  }));

  if (!response.ok) {
    const message = payload.message || `Lenco request failed with ${response.status}`;
    const error = new Error(message);
    error.statusCode = response.status;
    error.payload = payload;
    throw error;
  }
  return payload;
}

app.get('/health', (_req, res) => {
  res.json({ status: true, service: 'unistay-backend', lencoMock });
});

app.post('/api/auth/register', async (req, res) => {
  const { fullName, phone, email, password, role = 'student' } = req.body || {};

  if (!fullName || !phone || !email || !password) {
    res.status(400).json({ status: false, message: 'All fields are required' });
    return;
  }
  if (users.has(phone)) {
    res.status(409).json({ status: false, message: 'Phone number already exists' });
    return;
  }

  const user = {
    id: `user_${randomRef()}`,
    fullName,
    phone,
    email,
    role,
    passwordHash: await bcrypt.hash(password, 10),
    createdAt: new Date().toISOString(),
  };
  users.set(phone, user);

  res.status(201).json({
    status: true,
    message: 'Account created',
    data: { user: publicUser(user), token: signUser(user) },
  });
});

app.post('/api/auth/login', async (req, res) => {
  const { phone, password } = req.body || {};
  const user = users.get(phone);

  if (!user || !(await bcrypt.compare(password || '', user.passwordHash))) {
    res.status(401).json({ status: false, message: 'Invalid credentials' });
    return;
  }

  res.json({
    status: true,
    message: 'Login successful',
    data: { user: publicUser(user), token: signUser(user) },
  });
});

app.post('/api/payments/lenco/mobile-money', authRequired, async (req, res) => {
  const { amount, currency = 'ZMW', phone, operator = 'airtel', roomType } = req.body || {};
  const normalizedAmount = normalizeAmount(amount);

  if (!normalizedAmount || !phone || !['airtel', 'mtn', 'zamtel'].includes(operator)) {
    res.status(400).json({
      status: false,
      message: 'amount, phone, and a valid operator are required',
    });
    return;
  }

  const reference = createReference();
  const localRecord = {
    id: `pay_${randomRef()}`,
    userId: req.user.sub || req.user.id,
    roomType,
    amount: normalizedAmount.toFixed(2),
    currency,
    phone,
    operator,
    reference,
    status: 'pending',
    initiatedAt: new Date().toISOString(),
  };

  try {
    let payload;
    if (lencoMock) {
      payload = {
        status: true,
        message: 'Mock Lenco collection initiated',
        data: {
          ...localRecord,
          lencoReference: `MOCK-${randomRef()}`,
          type: 'mobile-money',
          status: 'pay-offline',
          source: 'api',
          bearer: 'merchant',
          mobileMoneyDetails: { country: 'zm', phone, operator },
        },
      };
    } else {
      payload = await callLenco('/collections/mobile-money', {
        method: 'POST',
        body: JSON.stringify({
          amount: normalizedAmount,
          reference,
          phone,
          operator,
          country: 'zm',
          bearer: 'merchant',
        }),
      });
    }

    const payment = { ...localRecord, ...payload.data };
    payments.set(reference, payment);
    res.status(201).json({ status: true, message: payload.message, data: payment });
  } catch (error) {
    res.status(error.statusCode || 502).json({
      status: false,
      message: error.message || 'Unable to start Lenco payment',
      data: error.payload || null,
    });
  }
});

app.get('/api/payments/lenco/:reference', authRequired, async (req, res) => {
  const { reference } = req.params;
  const localPayment = payments.get(reference);

  if (!localPayment) {
    res.status(404).json({ status: false, message: 'Payment reference not found' });
    return;
  }

  try {
    let payload;
    if (lencoMock) {
      const ageMs = Date.now() - new Date(localPayment.initiatedAt).getTime();
      const status = ageMs > 2000 ? 'successful' : localPayment.status || 'pay-offline';
      payload = {
        status: true,
        message: 'Mock Lenco collection status',
        data: {
          ...localPayment,
          status,
          completedAt: status === 'successful' ? new Date().toISOString() : null,
          settlementStatus: status === 'successful' ? 'settled' : 'pending',
        },
      };
    } else {
      payload = await callLenco(`/collections/status/${encodeURIComponent(reference)}`);
    }

    payments.set(reference, { ...localPayment, ...payload.data });
    res.json({ status: true, message: payload.message, data: payments.get(reference) });
  } catch (error) {
    res.status(error.statusCode || 502).json({
      status: false,
      message: error.message || 'Unable to verify Lenco payment',
      data: error.payload || null,
    });
  }
});

app.post('/api/webhooks/lenco', express.raw({ type: 'application/json' }), (req, res) => {
  res.json({ status: true, message: 'Webhook received' });
});

app.use((req, res) => {
  res.status(404).json({ status: false, message: 'Route not found' });
});

app.listen(port, () => {
  console.log(`UniStay backend listening on http://localhost:${port}`);
  console.log(`Lenco mode: ${lencoMock ? 'mock' : 'live'}`);
});
