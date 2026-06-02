/// Utility class for translating inventory item names to Uzbek
class ItemTranslator {
  // English to Uzbek translations
  static const Map<String, String> _translations = {
    // Bathroom items
    'Towel': 'Sochiq',
    'Towels': 'Sochiqlar',
    'Soap': 'Sovun',
    'Shampoo': 'Shampun',
    'Toilet paper': 'Tualet qog\'ozi',
    'Toilet Paper': 'Tualet qog\'ozi',
    'Toothbrush': 'Tish cho\'tkasi',
    'Toothpaste': 'Tish pastasi',
    'Conditioner': 'Soch kondisioneri',
    'Body lotion': 'Tana losyoni',
    'Body Lotion': 'Tana losyoni',
    'Shower cap': 'Dush qalpoq',
    'Shower Cap': 'Dush qalpoq',
    
    // Bedroom items
    'Slippers': 'Shippak',
    'Pillow': 'Yostiq',
    'Blanket': 'Ko\'rpa',
    'Bed sheet': 'Choyshab',
    'Bed Sheet': 'Choyshab',
    'Bed Sheets': 'Choyshablar',
    'Pillowcase': 'Yostiq qopi',
    
    // Cleaning items
    'Cleaning spray': 'Tozalash spreyi',
    'Cleaning Spray': 'Tozalash spreyi',
    'Mop': 'Mop (latta)',
    'Vacuum bags': 'Changyutgich qoplari',
    'Vacuum Bags': 'Changyutgich qoplari',
    'Trash bags': 'Axlat qoplari',
    'Trash Bags': 'Axlat qoplari',
    
    // Minibar items
    'Coffee': 'Qahva',
    'Tea': 'Choy',
    'Sugar': 'Shakar',
    'Water bottle': 'Suv shishasi',
    'Water Bottle': 'Suv shishasi',
    'Glass': 'Stakan',
    
    // Common variations
    'towel': 'sochiq',
    'soap': 'sovun',
    'shampoo': 'shampun',
  };

  /// Translate item name from English to Uzbek
  /// If translation not found, returns original name
  static String translate(String? itemName) {
    if (itemName == null || itemName.isEmpty) return 'Buyum';
    
    // Try exact match first
    if (_translations.containsKey(itemName)) {
      return _translations[itemName]!;
    }
    
    // Try case-insensitive match
    final lowerName = itemName.toLowerCase();
    for (var entry in _translations.entries) {
      if (entry.key.toLowerCase() == lowerName) {
        return entry.value;
      }
    }
    
    // Return original if no translation found
    return itemName;
  }

  /// Translate category name to Uzbek
  static String translateCategory(String? category) {
    if (category == null || category.isEmpty) return 'Boshqalar';
    
    switch (category.toUpperCase()) {
      case 'BATHROOM':
        return 'Hammom buyumlari';
      case 'BEDROOM':
      case 'BEDDING':
        return 'Yotoq buyumlari';
      case 'CLEANING':
        return 'Tozalash vositalari';
      case 'MINIBAR':
        return 'Minibar';
      case 'OTHER':
        return 'Boshqalar';
      default:
        return category;
    }
  }

  /// Get all available translations
  static Map<String, String> get allTranslations => Map.unmodifiable(_translations);
}
