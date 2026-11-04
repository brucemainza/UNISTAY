part of '../../main.dart';

class EnquireScreen extends StatefulWidget {
  const EnquireScreen({super.key, required this.room});

  final Room room;

  @override
  State<EnquireScreen> createState() => _EnquireScreenState();
}

class _EnquireScreenState extends State<EnquireScreen> {
  late final TextEditingController messageController = TextEditingController(
    text: 'Hi Mr Chanda, is this room available?',
  );

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const UniAppBar(title: 'Enquire about this room'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _FlowHouseHeader(room: widget.room),
          const SizedBox(height: 20),
          const Text(
            'Send a message to Mr Chanda before you book.',
            style: TextStyle(color: grayText),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final question in const [
                'Is this available?',
                'Can I visit?',
                'Is water included?',
              ])
                ActionChip(
                  label: Text(question),
                  onPressed: () => messageController.text = question,
                ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Your message',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: messageController,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (messageController.text.trim().isEmpty) {
                showSnack(context, 'Enter a message first');
                return;
              }
              showSnack(context, 'Enquiry sent to the landlord');
            },
            child: const Text('Send enquiry'),
          ),
          const SizedBox(height: 12),
          const Text(
            'Replies will be sent by SMS or WhatsApp.',
            textAlign: TextAlign.center,
            style: TextStyle(color: grayText, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
