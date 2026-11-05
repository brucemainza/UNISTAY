part of '../../main.dart';

// Student Market reference screens.  They deliberately share a small set of
// building blocks so each route feels like one polished product.
const _marketInk = Color(0xFF2B2826);
const _marketMuted = Color(0xFF786F68);
const _marketPeach = Color(0xFFFFEDE1);
const _marketLine = Color(0xFFE8DDD5);

class MarketplaceHomeScreen extends StatefulWidget {
  const MarketplaceHomeScreen({super.key});
  @override
  State<MarketplaceHomeScreen> createState() => _MarketplaceHomeScreenState();
}

class _MarketplaceHomeScreenState extends State<MarketplaceHomeScreen> {
  String category = 'All';
  final search = TextEditingController();
  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  void _nav(int index) {
    final routes = [
      Routes.home,
      Routes.map,
      Routes.saved,
      Routes.market,
      Routes.account,
    ];
    if (index != 3) Navigator.pushReplacementNamed(context, routes[index]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: UniBottomNavigationDock(
      selectedTabIndex: 3,
      onTabSelected: _nav,
    ),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
        children: [
          Row(
            children: [
              _orangeSquare(Icons.shopping_bag_outlined),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Student Market',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
              _circleButton(
                Icons.add,
                () => Navigator.pushNamed(context, Routes.postService),
              ),
              const SizedBox(width: 8),
              _circleButton(
                Icons.storefront_outlined,
                () => Navigator.pushNamed(context, Routes.myServices),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: orangePrimary),
              SizedBox(width: 4),
              Text(
                'Lusaka Â· Around your campus',
                style: TextStyle(
                  color: _marketMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Icon(Icons.keyboard_arrow_down, color: _marketMuted),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Find help.\nKeep student life\nmoving.',
            style: TextStyle(
              fontSize: 31,
              height: 1.12,
              fontWeight: FontWeight.w900,
              color: _marketInk,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'From repairs to tutoring, discover local services near campus.',
            style: TextStyle(color: _marketMuted, fontSize: 15, height: 1.4),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: search,
            decoration: _field(
              'Search services or vendors',
              prefix: Icons.search_outlined,
              suffix: Icons.tune_outlined,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ['All', 'Fridge & Stove Repair', 'Laptop Repair']
                  .map(
                    (value) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(value),
                        selected: category == value,
                        selectedColor: orangePrimary,
                        labelStyle: TextStyle(
                          color: category == value ? Colors.white : _marketInk,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        side: const BorderSide(color: _marketLine),
                        onSelected: (_) => setState(() => category = value),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Available near you',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ),
              Text(
                category == 'All' ? '8 listings' : '1 listing',
                style: const TextStyle(color: _marketMuted, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _marketListing(context),
          const SizedBox(height: 24),
          _peachCard(
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Got a skill? Put it to work.',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Create a service profile for students to discover.',
                        style: TextStyle(color: _marketMuted, fontSize: 13),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Post your service â†’',
                        style: TextStyle(
                          color: orangePrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.business_center_outlined,
                  color: orangePrimary,
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _marketListing(BuildContext context) => InkWell(
  onTap: () => Navigator.pushNamed(context, Routes.serviceProfile),
  borderRadius: BorderRadius.circular(20),
  child: Container(
    decoration: _cardDecoration(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cover(height: 151, compact: true),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Mutale Fix-It',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const Icon(Icons.star_border, color: orangePrimary, size: 18),
                  const Text(
                    ' 4.6 (73)',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Same-day fixes for fridges, stoves and heaters',
                style: TextStyle(color: _marketMuted),
              ),
              const SizedBox(height: 12),
              const Text(
                'Fridge & Stove Repair',
                style: TextStyle(
                  color: orangePrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 12),
              const Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: _marketMuted,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Matero, Lusaka (travels)',
                    style: TextStyle(color: _marketMuted, fontSize: 13),
                  ),
                ],
              ),
              const Divider(height: 28, color: _marketLine),
              Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'FROM',
                        style: TextStyle(color: _marketMuted, fontSize: 10),
                      ),
                      Text(
                        'K80',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Text(
                    'View service  â†—',
                    style: TextStyle(
                      color: orangePrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);

class ServiceProfileScreen extends StatelessWidget {
  const ServiceProfileScreen({super.key});
  @override
  Widget build(BuildContext context) => _marketScaffold(
    context,
    title: 'Service profile',
    actions: [
      IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
    ],
    child: ListView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 28),
      children: [
        _cover(height: 177),
        const SizedBox(height: 25),
        const Text(
          'Mutale Fix-It',
          style: TextStyle(fontSize: 31, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        _tag('Fridge & Stove Repair'),
        const SizedBox(height: 12),
        const Row(
          children: [
            Icon(Icons.star_border, color: orangePrimary),
            SizedBox(width: 7),
            Text('4.6', style: TextStyle(fontWeight: FontWeight.w800)),
            SizedBox(width: 8),
            Text('(73 reviews)', style: TextStyle(color: _marketMuted)),
          ],
        ),
        const SizedBox(height: 12),
        const Row(
          children: [
            Icon(Icons.location_on_outlined, color: _marketMuted),
            SizedBox(width: 7),
            Text(
              'Matero, Lusaka (travels)',
              style: TextStyle(color: _marketMuted),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _primaryButton(
          'Message on WhatsApp',
          Icons.chat_bubble_outline,
          () => showSnack(context, 'Opening WhatsAppâ€¦'),
        ),
        const SizedBox(height: 20),
        const Row(
          children: [
            Text(
              'About',
              style: TextStyle(
                color: orangePrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            Spacer(),
            Text(
              'Catalog',
              style: TextStyle(
                color: _marketMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
            Spacer(),
            Text(
              'Contact',
              style: TextStyle(
                color: _marketMuted,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Divider(color: _marketLine, height: 24),
        const Text(
          'About Mutale Fix-It',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 10),
        const Text(
          'Fridge not cooling? Stove element dead? I diagnose on the spot and quote before I touch anything. Call-outs to hostels and flats across Lusaka.',
          style: TextStyle(color: _marketMuted, height: 1.5),
        ),
        const SizedBox(height: 25),
        _catalogSection(context, showAll: false),
        const SizedBox(height: 25),
        const Text(
          'Letâ€™s get it fixed.',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 7),
        const Text(
          'Tell Mutale whatâ€™s wrong and ask about a call-out.',
          style: TextStyle(color: _marketMuted),
        ),
        const SizedBox(height: 20),
        const Text(
          'PHONE AND WHATSAPP',
          style: TextStyle(
            color: _marketMuted,
            fontSize: 10,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '0977 000 101',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 18),
        _primaryButton('Message on WhatsApp', Icons.chat_bubble_outline, () {}),
        const SizedBox(height: 11),
        _outlineButton('Call Mutale', Icons.phone_outlined, () {}),
        const SizedBox(height: 28),
        _reviewsPreview(context),
      ],
    ),
  );
}

class MyServicesScreen extends StatelessWidget {
  const MyServicesScreen({super.key});
  @override
  Widget build(BuildContext context) => _marketScaffold(
    context,
    title: 'My services',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      children: [
        const Text(
          'PROVIDER WORKSPACE',
          style: TextStyle(
            color: orangePrimary,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: .5,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Your skills. Your space.',
          style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        const Text(
          'Keep your service profile and catalog up to date, all in one place.',
          style: TextStyle(color: _marketMuted, fontSize: 15),
        ),
        const SizedBox(height: 24),
        _cover(height: 181),
        const SizedBox(height: 40),
        const Row(
          children: [
            Chip(
              label: Text(
                'â€¢ Live on marketplace',
                style: TextStyle(
                  color: Color(0xFF28764E),
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
              backgroundColor: Color(0xFFE8F4EC),
              side: BorderSide.none,
            ),
            Spacer(),
            Text(
              'Your listing',
              style: TextStyle(color: _marketMuted, fontSize: 12),
            ),
          ],
        ),
        const Text(
          'Mutale Fix-It',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
        ),
        const SizedBox(height: 7),
        const Text(
          'Fridge & Stove Repair',
          style: TextStyle(color: orangePrimary, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        const Text(
          'Matero, Lusaka (travels)',
          style: TextStyle(color: _marketMuted),
        ),
        const SizedBox(height: 13),
        const Row(
          children: [
            Text('â˜… 4.6 (73 reviews)'),
            Spacer(),
            Text('3 catalog items', style: TextStyle(color: _marketMuted)),
          ],
        ),
        const SizedBox(height: 16),
        _outlineButton(
          'View listing',
          Icons.north_east,
          () => Navigator.pushNamed(context, Routes.serviceProfile),
        ),
        const SizedBox(height: 36),
        const Text(
          'Make it yours',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
        ),
        const SizedBox(height: 12),
        _settingsRow(
          context,
          Icons.edit_outlined,
          'Edit service profile',
          'Business details, cover and social URLs',
          Routes.editService,
        ),
        _settingsRow(
          context,
          Icons.grid_view_outlined,
          'Manage catalog',
          'Add, edit or remove your 3 items',
          Routes.manageCatalog,
        ),
        const SizedBox(height: 24),
        _peachCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.visibility_outlined, color: orangePrimary),
                  SizedBox(width: 10),
                  Text(
                    'Listing visibility',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Taking a break? Pause your listing to hide it from browse and search. Your profile, items and reviews stay saved.',
                style: TextStyle(color: _marketMuted, height: 1.4),
              ),
              const SizedBox(height: 15),
              _outlineButton(
                'Pause listing',
                Icons.pause_circle_outline,
                () => showSnack(context, 'Your listing is still live'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _primaryButton(
          'Post a new service',
          Icons.add,
          () => Navigator.pushNamed(context, Routes.postService),
        ),
      ],
    ),
  );
}

class ManageCatalogScreen extends StatelessWidget {
  const ManageCatalogScreen({super.key});
  @override
  Widget build(BuildContext context) => _marketScaffold(
    context,
    title: 'Manage catalog',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      children: [
        const Text(
          'What can you help with?',
          style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        const Text(
          'Keep your services and prices easy for students to explore.',
          style: TextStyle(color: _marketMuted, fontSize: 15),
        ),
        const SizedBox(height: 24),
        _providerTile(),
        const SizedBox(height: 23),
        _primaryButton(
          'Add catalog item',
          Icons.add,
          () => Navigator.pushNamed(context, Routes.addCatalogItem),
        ),
        const SizedBox(height: 25),
        const Row(
          children: [
            Text(
              'Your catalog',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            Spacer(),
            Text(
              '3 items',
              style: TextStyle(color: _marketMuted, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._items.map((item) => _catalogManager(context, item)),
        const SizedBox(height: 24),
        _peachCard(
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: orangePrimary),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your catalog is part of your listing',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Changes to items and prices appear on your full service profile. Removing an item wonâ€™t remove your service listing.',
                      style: TextStyle(color: _marketMuted, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _outlineButton(
          'Back to My services',
          null,
          () => Navigator.pop(context),
        ),
      ],
    ),
  );
}

class CatalogItemScreen extends StatefulWidget {
  const CatalogItemScreen({super.key, this.editing = false});
  final bool editing;
  @override
  State<CatalogItemScreen> createState() => _CatalogItemScreenState();
}

class _CatalogItemScreenState extends State<CatalogItemScreen> {
  late final TextEditingController name = TextEditingController(
    text: widget.editing ? 'Call-out and diagnosis' : '',
  );
  late final TextEditingController price = TextEditingController(
    text: widget.editing ? '80' : '',
  );
  final desc = TextEditingController();
  @override
  void dispose() {
    name.dispose();
    price.dispose();
    desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final edit = widget.editing;
    return _marketScaffold(
      context,
      title: edit ? 'Edit catalog item' : 'Add catalog item',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
        children: [
          Text(
            edit ? 'Fine-tune your offering.' : 'Add to your catalog.',
            style: const TextStyle(fontSize: 29, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            edit
                ? 'Update this item without changing the rest of your catalog.'
                : 'Give students a clear idea of what you offer and what it costs.',
            style: const TextStyle(color: _marketMuted, fontSize: 15),
          ),
          const SizedBox(height: 24),
          _providerTile(),
          const SizedBox(height: 25),
          _label('Item name'),
          TextField(
            controller: name,
            decoration: _field('e.g. Appliance maintenance'),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use a short, specific name for this service.',
            style: TextStyle(color: _marketMuted, fontSize: 12),
          ),
          const SizedBox(height: 20),
          _label('Description'),
          TextField(
            controller: desc,
            maxLines: 4,
            maxLength: 400,
            decoration: _field(
              'Describe whatâ€™s included and what students should know before booking.',
            ),
          ),
          const SizedBox(height: 15),
          _label('Price'),
          TextField(
            controller: price,
            keyboardType: TextInputType.number,
            decoration: _field('0.00', prefixText: 'K   ', suffixText: 'ZMW'),
          ),
          const SizedBox(height: 10),
          const Text(
            'Enter the price in Zambian kwacha. Explain any extras in the description.',
            style: TextStyle(color: _marketMuted, fontSize: 12),
          ),
          const SizedBox(height: 20),
          _label('Item image Â· Optional'),
          const SizedBox(height: 8),
          _photoPlaceholder(
            'Add an item image',
            'JPG or PNG Â· Show the item or your work',
          ),
          const SizedBox(height: 24),
          _primaryButton(
            edit ? 'Save changes' : 'Add item to catalog',
            edit ? Icons.check : Icons.add,
            () {
              showSnack(
                context,
                edit ? 'Catalog item updated' : 'Item added to catalog',
              );
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 12),
          _outlineButton('Cancel', null, () => Navigator.pop(context)),
          if (edit) ...[
            const Divider(height: 48, color: _marketLine),
            const Text(
              'Remove this item',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'â€œCall-out and diagnosisâ€ will be removed from your catalog. Your other items and service profile will stay.',
              style: TextStyle(color: _marketMuted),
            ),
            const SizedBox(height: 12),
            _dangerButton(
              'Remove item',
              Icons.delete_outline,
              () => Navigator.pop(context),
            ),
          ],
        ],
      ),
    );
  }
}

class EditServiceScreen extends StatelessWidget {
  const EditServiceScreen({super.key});
  @override
  Widget build(BuildContext context) => _ServiceForm(
    title: 'Edit service',
    headline: 'Keep your profile fresh.',
    editing: true,
  );
}

class PostServiceScreen extends StatelessWidget {
  const PostServiceScreen({super.key});
  @override
  Widget build(BuildContext context) => _ServiceForm(
    title: 'Post your service',
    headline: 'Turn your skills into\nOpportunities',
    editing: false,
  );
}

class _ServiceForm extends StatefulWidget {
  const _ServiceForm({
    required this.title,
    required this.headline,
    required this.editing,
  });
  final String title, headline;
  final bool editing;
  @override
  State<_ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<_ServiceForm> {
  late final name = TextEditingController(
    text: widget.editing ? 'Mutale Fix-It' : '',
  );
  late final phone = TextEditingController(
    text: widget.editing ? '0977 000 101' : '',
  );
  late final location = TextEditingController(
    text: widget.editing ? 'Matero, Lusaka (travels)' : '',
  );
  late final pitch = TextEditingController(
    text: widget.editing
        ? 'Same-day fixes for fridges, stoves and heaters'
        : '',
  );
  late final about = TextEditingController(
    text: widget.editing
        ? 'Fridge not cooling? Stove element dead? I diagnose on the spot and quote before I touch anything. Call-outs to hostels and flats across Lusaka.'
        : '',
  );
  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    location.dispose();
    pitch.dispose();
    about.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final edit = widget.editing;
    return _marketScaffold(
      context,
      title: widget.title,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        children: [
          Text(
            widget.headline,
            style: const TextStyle(
              fontSize: 29,
              height: 1.08,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            edit
                ? 'Update what students see when they discover your service.'
                : 'Create a profile students can browse, call and message YOU!.',
            style: const TextStyle(color: _marketMuted, fontSize: 15),
          ),
          const SizedBox(height: 28),
          _label('Cover photo'),
          const SizedBox(height: 8),
          edit
              ? _cover(height: 180)
              : _photoPlaceholder(
                  'Add a cover photo',
                  'Show your work, workspace or service.',
                ),
          if (edit) ...[
            const SizedBox(height: 10),
            _outlineButton(
              'Change cover photo',
              Icons.add_photo_alternate_outlined,
              () {},
            ),
          ],
          const SizedBox(height: 27),
          const Text(
            'The essentials',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
          ),
          const SizedBox(height: 18),
          _label('Business or your name'),
          TextField(controller: name, decoration: _field('e.g. Mutale Fix-It')),
          const SizedBox(height: 17),
          _label('Category'),
          DropdownButtonFormField<String>(
            initialValue: edit ? 'Fridge & Stove Repair' : null,
            decoration: _field('Choose your service category'),
            items: const [
              'Fridge & Stove Repair',
              'Laptop Repair',
              'Phone Repair',
              'Tutoring',
            ].map((x) => DropdownMenuItem(value: x, child: Text(x))).toList(),
            onChanged: (_) {},
          ),
          const SizedBox(height: 17),
          _label('Phone and WhatsApp number'),
          TextField(
            controller: phone,
            decoration: _field('e.g. 0977 000 101'),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 7),
          const Text(
            'Use the number customers can call or message.',
            style: TextStyle(color: _marketMuted, fontSize: 12),
          ),
          const SizedBox(height: 17),
          _label('Where you work'),
          TextField(
            controller: location,
            decoration: _field(
              'e.g. Matero, Lusaka',
              suffix: Icons.location_on_outlined,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Include the areas you travel to, if applicable.',
            style: TextStyle(color: _marketMuted, fontSize: 12),
          ),
          const SizedBox(height: 28),
          const Text(
            'Tell students what you do',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
          ),
          const SizedBox(height: 18),
          _label('One-line pitch'),
          TextField(
            controller: pitch,
            maxLength: 80,
            decoration: _field('A short introduction to your service'),
          ),
          const SizedBox(height: 13),
          _label('About you (hours, experience, call-outs)'),
          TextField(
            controller: about,
            maxLines: 5,
            maxLength: 400,
            decoration: _field(
              'Describe your service, when you work and how students can book you.',
            ),
          ),
          const SizedBox(height: 25),
          _socialFields(),
          if (!edit) ...[
            const SizedBox(height: 28),
            const Text(
              'Catalog setup',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            _peachCard(
              child: const Row(
                children: [
                  Icon(Icons.add, color: orangePrimary),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add services and prices',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Create your first catalog item after publishing, or finish setup later from My services.',
                          style: TextStyle(color: _marketMuted, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 26),
          _primaryButton(
            edit ? 'Save changes' : 'Publish profile',
            edit ? Icons.check : Icons.north_east,
            () {
              showSnack(
                context,
                edit ? 'Service profile saved' : 'Your service is now live',
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                edit ? Routes.myServices : Routes.myServices,
                (r) => r.settings.name == Routes.market,
              );
            },
          ),
          const SizedBox(height: 11),
          _outlineButton('Cancel', null, () => Navigator.pop(context)),
          if (edit) ...[
            const Divider(height: 48, color: _marketLine),
            const Text(
              'Remove this service',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
            ),
            const SizedBox(height: 9),
            const Text(
              'This removes your listing and its catalog from Student Market. To take a break instead, pause it in My services.',
              style: TextStyle(color: _marketMuted),
            ),
            const SizedBox(height: 12),
            _dangerButton(
              'Remove service',
              Icons.delete_outline,
              () => Navigator.pop(context),
            ),
          ],
        ],
      ),
    );
  }
}

class AllReviewsScreen extends StatelessWidget {
  const AllReviewsScreen({super.key});
  @override
  Widget build(BuildContext context) => _marketScaffold(
    context,
    title: 'All reviews',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 25),
      children: [
        const Text(
          'Hear from the community.',
          style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        const Text(
          'Student experiences with Mutale Fix-It.',
          style: TextStyle(color: _marketMuted, fontSize: 15),
        ),
        const SizedBox(height: 24),
        _providerTile(),
        const SizedBox(height: 24),
        _ratingBlock(),
        const SizedBox(height: 25),
        const Text(
          'Used this service?',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
        const SizedBox(height: 9),
        _primaryButton(
          'Write a review',
          Icons.star_border,
          () => Navigator.pushNamed(context, Routes.rateService),
        ),
        const SizedBox(height: 24),
        _reviewsList(context),
        _outlineButton('Show more reviews', null, () {}),
      ],
    ),
  );
}

class RateServiceScreen extends StatefulWidget {
  const RateServiceScreen({super.key});
  @override
  State<RateServiceScreen> createState() => _RateServiceScreenState();
}

class _RateServiceScreenState extends State<RateServiceScreen> {
  int rating = 4;
  final review = TextEditingController(
    text:
        'The problem was explained clearly and the quote was easy to understand. A helpful experience overall.',
  );
  @override
  void dispose() {
    review.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _marketScaffold(
    context,
    title: 'Rate service',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
      children: [
        const Text(
          'COMMUNITY FEEDBACK',
          style: TextStyle(
            color: orangePrimary,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: .5,
          ),
        ),
        const SizedBox(height: 11),
        const Text(
          'How was your\nexperience?',
          style: TextStyle(
            fontSize: 29,
            height: 1.1,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 9),
        const Text(
          'Your honest feedback helps other students choose the right local service.',
          style: TextStyle(color: _marketMuted, fontSize: 15),
        ),
        const SizedBox(height: 28),
        _providerTile(),
        const SizedBox(height: 28),
        _peachCard(
          child: Column(
            children: [
              const Text(
                'Your rating',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => IconButton(
                    onPressed: () => setState(() => rating = i + 1),
                    icon: Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: orangePrimary,
                      size: 37,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$rating of 5 Â· ${rating >= 4 ? 'Good' : 'Fair'}',
                  style: const TextStyle(
                    color: orangePrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Tap a star to change your rating',
                style: TextStyle(color: _marketMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _label('Written review Â· Optional'),
        TextField(
          controller: review,
          maxLines: 5,
          decoration: _field('Share your experience'),
        ),
        const SizedBox(height: 10),
        const Text(
          'Share what went well or what could be better. No phone numbers or private details.',
          style: TextStyle(color: _marketMuted, fontSize: 12),
        ),
        const SizedBox(height: 26),
        _peachCard(
          child: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, color: orangePrimary),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Keep it fair and first-hand',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Only rate a service youâ€™ve used. You canâ€™t review your own listing. Your rating and written review will be public on the service profile.',
                      style: TextStyle(color: _marketMuted, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _primaryButton(
          'Submit review',
          Icons.north_east,
          () => Navigator.pushReplacementNamed(context, Routes.reviewSubmitted),
        ),
        const SizedBox(height: 11),
        _outlineButton('Cancel', null, () => Navigator.pop(context)),
      ],
    ),
  );
}

class ReviewSubmittedScreen extends StatelessWidget {
  const ReviewSubmittedScreen({super.key});
  @override
  Widget build(BuildContext context) => _marketScaffold(
    context,
    title: 'Review submitted',
    close: true,
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 74,
              height: 74,
              decoration: const BoxDecoration(
                color: _marketPeach,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: orangePrimary,
                size: 57,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Thanks for sharing.',
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your rating and review for Mutale Fix-It have been submitted.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _marketMuted, fontSize: 15),
            ),
            const SizedBox(height: 30),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: _cardDecoration(),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'YOUR REVIEW',
                    style: TextStyle(
                      color: orangePrimary,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Mutale Fix-It',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 19),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'â˜…â˜…â˜…â˜…â˜†   4 of 5',
                    style: TextStyle(
                      color: orangePrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'The problem was explained clearly and the quote was easy to understand. A helpful experience overall.',
                    style: TextStyle(height: 1.45),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'â—‰  Submitted successfully',
                    style: TextStyle(
                      color: Color(0xFF28764E),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 26),
            const Text(
              'A little feedback goes a long way in helping the student community.',
              textAlign: TextAlign.center,
              style: TextStyle(color: _marketMuted),
            ),
            const SizedBox(height: 28),
            _primaryButton(
              'Return to service',
              Icons.arrow_forward,
              () => Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.serviceProfile,
                (r) => r.settings.name == Routes.market,
              ),
            ),
            const SizedBox(height: 11),
            _outlineButton(
              'Browse marketplace',
              Icons.storefront_outlined,
              () => Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.market,
                (r) => false,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _marketScaffold(
  BuildContext context, {
  required String title,
  required Widget child,
  List<Widget>? actions,
  bool close = false,
}) => Scaffold(
  appBar: AppBar(
    leadingWidth: 76,
    leading: Padding(
      padding: const EdgeInsets.only(left: 16, top: 7, bottom: 7),
      child: OutlinedButton(
        onPressed: () => Navigator.maybePop(context),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: _marketLine),
        ),
        child: Icon(
          close ? Icons.close : Icons.arrow_back,
          color: orangePrimary,
        ),
      ),
    ),
    title: Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
    ),
    centerTitle: false,
    actions: actions,
  ),
  body: SafeArea(top: false, child: child),
);
Widget _orangeSquare(IconData icon) => Container(
  width: 38,
  height: 38,
  decoration: BoxDecoration(
    color: orangePrimary,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Icon(icon, color: Colors.white),
);
Widget _circleButton(IconData icon, VoidCallback tap) => InkWell(
  onTap: tap,
  borderRadius: BorderRadius.circular(24),
  child: Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(color: _marketPeach, shape: BoxShape.circle),
    child: Icon(icon, color: orangePrimary),
  ),
);
BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20),
  border: Border.all(color: _marketLine),
);
Widget _peachCard({required Widget child}) => Container(
  padding: const EdgeInsets.all(18),
  decoration: BoxDecoration(
    color: _marketPeach,
    borderRadius: BorderRadius.circular(18),
  ),
  child: child,
);
Widget _cover({required double height, bool compact = false}) => Container(
  height: height,
  decoration: BoxDecoration(
    color: const Color(0xFFF7E6D3),
    borderRadius: BorderRadius.circular(compact ? 20 : 20),
  ),
  child: Stack(
    children: [
      Positioned(left: 20, top: 22, child: _orangeSquare(Icons.person_outline)),
      Positioned(
        left: 20,
        bottom: 20,
        child: Text(
          compact
              ? 'Fridge trouble?\nStove stopped?'
              : 'Fridge &\nstove repair.',
          style: TextStyle(
            fontSize: compact ? 19 : 24,
            height: 1.05,
            fontWeight: FontWeight.w900,
            color: _marketInk,
          ),
        ),
      ),
      if (!compact)
        const Positioned(
          left: 20,
          bottom: 8,
          child: Text(
            'MATERO Â· LUSAKA',
            style: TextStyle(
              color: orangePrimary,
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
          ),
        ),
      Positioned(
        right: 23,
        top: 20,
        child: Icon(
          Icons.kitchen_rounded,
          color: const Color(0xFFE7D3A9),
          size: height * .58,
        ),
      ),
      Positioned(
        right: 12,
        bottom: 13,
        child: Icon(
          Icons.handyman_rounded,
          color: const Color(0xFF9B4524),
          size: height * .43,
        ),
      ),
      if (compact)
        const Positioned(
          left: 20,
          top: 44,
          child: Text(
            'LOCAL REPAIR SERVICES',
            style: TextStyle(
              color: orangePrimary,
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
    ],
  ),
);
InputDecoration _field(
  String hint, {
  IconData? prefix,
  IconData? suffix,
  String? prefixText,
  String? suffixText,
}) => InputDecoration(
  hintText: hint,
  prefixIcon: prefix == null ? null : Icon(prefix, color: _marketMuted),
  suffixIcon: suffix == null ? null : Icon(suffix, color: _marketMuted),
  prefixText: prefixText,
  suffixText: suffixText,
  suffixStyle: const TextStyle(color: _marketMuted, fontSize: 12),
  hintStyle: const TextStyle(color: _marketMuted, fontSize: 14),
  isDense: true,
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: _marketLine),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: _marketLine),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: orangePrimary, width: 1.5),
  ),
);
Widget _label(String label) => Padding(
  padding: const EdgeInsets.only(bottom: 8),
  child: Text(
    label,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
  ),
);
Widget _tag(String text) => Container(
  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
  decoration: BoxDecoration(
    color: _marketPeach,
    borderRadius: BorderRadius.circular(18),
  ),
  child: Text(
    text,
    style: const TextStyle(
      color: orangePrimary,
      fontWeight: FontWeight.w700,
      fontSize: 12,
    ),
  ),
);
Widget _primaryButton(String text, IconData? icon, VoidCallback tap) =>
    SizedBox(
      height: 53,
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: tap,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 20),
        label: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: orangePrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
Widget _outlineButton(String text, IconData? icon, VoidCallback tap) =>
    SizedBox(
      height: 53,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: tap,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 20),
        label: Text(
          text,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: _marketInk,
          side: const BorderSide(color: _marketLine),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
Widget _dangerButton(String text, IconData icon, VoidCallback tap) => SizedBox(
  height: 53,
  child: OutlinedButton.icon(
    onPressed: tap,
    icon: Icon(icon),
    label: Text(text, style: const TextStyle(fontWeight: FontWeight.w800)),
    style: OutlinedButton.styleFrom(
      foregroundColor: const Color(0xFFD8352B),
      side: const BorderSide(color: Color(0xFFD8352B)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
);
Widget _providerTile() => Container(
  padding: const EdgeInsets.all(16),
  decoration: _cardDecoration(),
  child: const Row(
    children: [
      CircleAvatar(
        backgroundColor: _marketPeach,
        child: Text(
          'M',
          style: TextStyle(
            color: Color(0xFFC54B0B),
            fontWeight: FontWeight.w900,
            fontSize: 23,
          ),
        ),
      ),
      SizedBox(width: 12),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mutale Fix-It',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
          ),
          SizedBox(height: 3),
          Text(
            'Fridge & Stove Repair',
            style: TextStyle(color: _marketMuted, fontSize: 12),
          ),
        ],
      ),
    ],
  ),
);
const _items = [
  ('Call-out and diagnosis', 80, Icons.handyman_outlined),
  ('Fridge re-gas', 350, Icons.kitchen_outlined),
  ('Stove element replacement', 180, Icons.square_outlined),
];
Widget _catalogSection(BuildContext context, {required bool showAll}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Row(
      children: [
        const Text(
          'Catalog',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        Text(
          '3 services',
          style: const TextStyle(color: _marketMuted, fontSize: 12),
        ),
      ],
    ),
    const SizedBox(height: 12),
    ..._items.map(
      (x) => Padding(
        padding: const EdgeInsets.only(bottom: 11),
        child: Container(
          padding: const EdgeInsets.all(13),
          decoration: _cardDecoration(),
          child: Row(
            children: [
              Container(
                width: 63,
                height: 63,
                decoration: BoxDecoration(
                  color: _marketPeach,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(x.$3, color: orangePrimary),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      x.$1,
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'K${x.$2}',
                      style: const TextStyle(
                        color: Color(0xFFC54B0B),
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: _marketMuted),
            ],
          ),
        ),
      ),
    ),
  ],
);
Widget _catalogManager(BuildContext context, (String, int, IconData) x) =>
    Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _marketPeach,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(x.$3, color: orangePrimary),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        x.$1,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'K${x.$2}',
                        style: const TextStyle(
                          color: Color(0xFFC54B0B),
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 25, color: _marketLine),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, Routes.editCatalogItem),
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text('Edit item'),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => showSnack(
                    context,
                    'Use Edit item to remove this listing',
                  ),
                  icon: const Icon(Icons.delete_outline, size: 17),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFD8352B),
                  ),
                  label: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
Widget _settingsRow(
  BuildContext context,
  IconData icon,
  String title,
  String sub,
  String route,
) => InkWell(
  onTap: () => Navigator.pushNamed(context, route),
  child: Padding(
    padding: const EdgeInsets.symmetric(vertical: 13),
    child: Row(
      children: [
        Container(
          width: 39,
          height: 39,
          decoration: BoxDecoration(
            color: _marketPeach,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: orangePrimary),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(
                sub,
                style: const TextStyle(color: _marketMuted, fontSize: 12),
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right, color: _marketMuted),
      ],
    ),
  ),
);
Widget _photoPlaceholder(String title, String sub) => Container(
  height: 149,
  decoration: BoxDecoration(
    color: _marketPeach,
    borderRadius: BorderRadius.circular(18),
    border: Border.all(
      color: const Color(0xFFDDB697),
      style: BorderStyle.solid,
    ),
  ),
  child: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.add_photo_alternate_outlined,
          color: orangePrimary,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFFC54B0B),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 5),
        Text(sub, style: const TextStyle(color: _marketMuted, fontSize: 12)),
      ],
    ),
  ),
);
Widget _socialFields() => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text(
      'Social accounts',
      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
    ),
    const SizedBox(height: 7),
    const Text(
      'Paste public profile URLs so students can find more of your work.',
      style: TextStyle(color: _marketMuted),
    ),
    const SizedBox(height: 15),
    _label('Facebook profile URL'),
    TextField(decoration: _field('https://www.facebook.com/your.page')),
    const SizedBox(height: 15),
    _label('Instagram profile URL'),
    TextField(decoration: _field('https://www.instagram.com/your.profile/')),
    TextButton.icon(
      onPressed: () {},
      icon: const Icon(Icons.add, color: orangePrimary),
      label: const Text(
        'Add another social URL',
        style: TextStyle(color: Color(0xFFC54B0B), fontWeight: FontWeight.w800),
      ),
    ),
  ],
);
Widget _ratingBlock() => _peachCard(
  child: const Row(
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '4.6',
            style: TextStyle(
              fontSize: 49,
              height: .9,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 12),
          Text('out of 5', style: TextStyle(color: _marketMuted, fontSize: 12)),
        ],
      ),
      SizedBox(width: 24),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '73 reviews',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
            SizedBox(height: 6),
            Text(
              'Overall service rating from the community',
              style: TextStyle(color: _marketMuted, height: 1.35),
            ),
          ],
        ),
      ),
    ],
  ),
);
const _reviewData = [
  (
    'Chanda M.',
    '2 days ago',
    5,
    'Explained what was wrong with the stove before starting. I knew what I was paying for and could ask questions.',
  ),
  (
    'Ruth K.',
    '5 days ago',
    5,
    'My fridge is cooling again. I appreciated the clear explanation of the problem and the repair.',
  ),
  (
    'Brian L.',
    '1 week ago',
    4,
    'Helpful with the diagnosis. We had to rearrange the call-out time, but he kept me updated.',
  ),
  (
    'Mwila S.',
    '2 weeks ago',
    5,
    'The stove element was replaced and everything was checked before he left. A straightforward experience.',
  ),
  (
    'Naomi C.',
    '3 weeks ago',
    4,
    'Easy to get in touch with and explained the quote clearly.',
  ),
  (
    'Peter B.',
    '1 month ago',
    3,
    'The diagnosis helped, though I needed to follow up about the next steps. Communication could have been better.',
  ),
];
Widget _reviewsList(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Row(
      children: [
        Text(
          'Reviews',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        Spacer(),
        Text(
          'Most recentâŒ„',
          style: TextStyle(color: _marketMuted, fontSize: 12),
        ),
      ],
    ),
    const Text(
      'Illustrative review entries Â· Source rating: 4.6 (73 reviews)',
      style: TextStyle(color: _marketMuted, fontSize: 10),
    ),
    const SizedBox(height: 10),
    ..._reviewData.map(
      (x) => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: const Color(0xFFF7F5F2),
                  child: Text(
                    x.$1.split(' ').map((e) => e[0]).join(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: _marketMuted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        x.$1,
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      Text(
                        x.$2,
                        style: const TextStyle(
                          color: _marketMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_horiz, color: _marketMuted),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'â˜…' * x.$3 + 'â˜†' * (5 - x.$3),
              style: const TextStyle(color: orangePrimary, fontSize: 19),
            ),
            const SizedBox(height: 7),
            Text(x.$4, style: const TextStyle(height: 1.45)),
            const Divider(height: 26, color: _marketLine),
          ],
        ),
      ),
    ),
  ],
);
Widget _reviewsPreview(BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    _reviewsList(context),
    _outlineButton(
      'View all reviews',
      null,
      () => Navigator.pushNamed(context, Routes.allReviews),
    ),
  ],
);


