import re
import urllib.parse
import codecs

query_map = {
    "پاستای ئەلفریدۆ": ("Alfredo Pasta", "alfredo pasta plate"),
    "پاستای ئەلفریدۆ لەگەڵ گۆشت": ("Alfredo Pasta with Meat", "alfredo pasta plate meat"),
    "پاستای سۆسی سوور لەگەڵ مریشک": ("Red Sauce Pasta with Chicken", "red sauce pasta chicken"),
    "پاستای سۆسی تێکەڵ": ("Mixed Sauce Pasta", "mixed sauce pasta"),
    "پاستای سۆس و گۆشت": ("Pasta with Sauce and Meat", "pasta meat sauce"),
    "پاستای موزاریلا": ("Mozzarella Pasta", "mozzarella pasta plate"),
    "ریزۆ": ("Rizo", "rizo chicken rice"),
    "برینج لەگەڵ مەرەق (شیلە)": ("Rice with Shila", "rice stew plate"),
    "کباب لەگەڵ برینج": ("Kebab with Rice", "kebab rice plate"),
    "تیکای مریشک لەگەڵ برینج": ("Chicken Tikka with Rice", "chicken tikka rice plate"),
    "تیکای گۆشت لەگەڵ برینج": ("Meat Tikka with Rice", "meat tikka rice plate"),
    "بریانی MM House": ("MM House Biryani", "biryani plate"),
    "برینج لەگەڵ مریشکی قواتە": ("Rice with Chicken Quarter", "chicken quarter rice plate"),
    "برینج لەگەڵ گازی گۆشت": ("Rice with Meat Gas", "meat shawarma rice plate"),
    "برینج لەگەڵ گازی مریشک": ("Rice with Chicken Gas", "chicken shawarma rice plate"),
    
    "یەک شیش کباب": ("One Shish Kebab", "shish kebab skewer"),
    "جگەر": ("Liver", "grilled liver skewers"),
    "تیکای مریشک": ("Chicken Tikka", "chicken tikka skewers"),
    "باڵی مریشک": ("Chicken Wings", "grilled chicken wings plate"),
    "دوو شیش کباب": ("Two Shish Kebabs", "two shish kebabs plate"),
    "تەبسی کباب تێکەڵ MM House": ("MM House Mixed Grill", "mixed grill meat plate"),
    "یەک شیش کباب تێکەڵ (محشی)": ("One Shish Kebab (Stuffed)", "stuffed kebab plate"),
    "تەشریبی گاز": ("Tashreeb Gas", "tashreeb dish meat bread"),
    "مریشکی تاوکراوی سادە": ("Simple Grilled Chicken", "grilled chicken plate"),
    "مریشکی تاوکراو لەگەڵ لیمۆ": ("Grilled Chicken with Lemon", "grilled chicken lemon plate"),
    "مریشکی تاوکراو لەگەڵ مەنگۆ": ("Grilled Chicken with Mango", "grilled chicken mango plate"),
    "مریشکی تاوکراو لەگەڵ بیبەر": ("Grilled Chicken with Pepper", "grilled chicken pepper plate"),
    "ساندویچی گازی مریشک": ("Chicken Gas Sandwich", "chicken shawarma sandwich"),
    "گازی گۆشت": ("Meat Gas", "meat shawarma plate"),
    "یەک تەبسی گازی گۆشت": ("Meat Gas Tray", "meat shawarma tray"),
    
    "یەک تەبسی شاوەرما": ("Shawarma Tray", "shawarma tray meal"),
    "شاوەرمای مریشک": ("Chicken Shawarma", "chicken shawarma wrap"),
    "شاوەرمای گۆشت": ("Meat Shawarma", "meat shawarma wrap"),
    "بێرگەر": ("Burger", "beef burger isolated"),
    "بێرگەری گاوی لەگەڵ پەنیر": ("Beef Burger with Cheese", "cheeseburger isolated"),
    "بێرگەری مریشک": ("Chicken Burger", "chicken burger isolated"),
    "بێرگەری مریشک لەگەڵ پەنیر": ("Chicken Burger with Cheese", "chicken cheeseburger"),
    "بێرگەری تاوی ئاگر": ("Fire Grilled Burger", "flame grilled burger"),
    
    "مریشکی کینتاکی — ١ پارچە": ("Kentucky Chicken - 1 Piece", "fried chicken piece"),
    "مریشکی کینتاکی — ٢ پارچە": ("Kentucky Chicken - 2 Pieces", "fried chicken pieces"),
    "مریشکی کینتاکی — ٤-٥ پارچە": ("Kentucky Chicken - 4-5 Pieces", "fried chicken bucket"),
    "مریشکی کینتاکی — ٨ پارچە": ("Kentucky Chicken - 8 Pieces", "fried chicken bucket large"),
    
    "بەژێی پیاز": ("Onion Bhaji", "onion bhaji pakora"),
    "سامبووسای گۆشت": ("Meat Samosa", "meat samosa isolated"),
    "سامبووسای سەوزە": ("Vegetable Samosa", "vegetable samosa isolated"),
    "فینگەر فرایز": ("French Fries", "french fries plate"),
    "فینگەر فرایز لەگەڵ سۆس": ("French Fries with Sauce", "french fries with cheese sauce"),
    "فینگەر وێجز لەگەڵ گۆشت": ("Potato Wedges with Meat", "potato wedges meat plate"),
    "فینگەر وێجز لەگەڵ سۆس": ("Potato Wedges with Sauce", "potato wedges sauce"),
    "فەلافەل": ("Falafel", "falafel balls plate"),
    "فەلافەلی تیژ لەگەڵ نان": ("Spicy Falafel with Bread", "spicy falafel wrap sandwich"),
    "کروکێت": ("Croquette", "potato croquettes"),
    "حەلقەی پیاز": ("Onion Rings", "onion rings plate"),
    "تەبسی پێشخواردنی گەورە": ("Large Muqabilat Tray", "large meze appetizer tray"),
    "تەبسی پێشخواردنی ناوەند": ("Medium Muqabilat Tray", "meze appetizer tray"),
    "تەبسی پێشخواردنی بچووک": ("Small Muqabilat Tray", "small hummus appetizer plate"),
    
    "ئاو": ("Water", "bottled water"),
    "پێپسی": ("Pepsi", "pepsi can drink"),
    "کۆلا": ("Cola", "coca cola can drink"),
    "سپرایت": ("Sprite", "sprite can drink"),
    "پێپسی دایت": ("Diet Pepsi", "diet pepsi can drink"),
    "پێپسی زیرۆ": ("Pepsi Zero", "pepsi zero can drink"),
    "دۆ": ("Doogh", "doogh yogurt drink"),
    "ماستاو": ("Mastaw", "ayran yogurt drink glass"),
    "میراندا": ("Miranda", "mirinda orange can drink"),
    "فانتا": ("Fanta", "fanta orange can drink"),
    "سێڤ ئەپ": ("7 Up", "7up can drink"),
    "چای": ("Tea", "black tea glass")
}

spellings = {
    "مریشکی قواتە": "تارێک",
    "دجاج قواطة": "تارێک",
    "تیکا": "تکەی",
    "تكة": "تکەی",
    "تەشریبی گاز": "تەشریب گەس",
    "تشريب غاز": "تەشریب گەس",
    "گاز": "گەس",
    "غاز": "گەس",
    "تاوکراوی": "بڕژاو",
    "تاوکراو": "بڕژاو",
    "مشوي": "بڕژاو",
    "تەبسی کباب تێکەڵ MM House": "سینی بڕژاوی تێکەڵی MM House",
    "صينية مشاوي مشكلة MM House": "سینی بڕژاوی تێکەڵی MM House",
    "پێشخواردنی": "موقەبیلات",
    "مقبلات": "موقەبیلات",
    "دوو شیش کباب": "دوو شیش کەباب",
    "یەک شیش کباب": "یەک شیش کەباب",
}

def fix_spelling(text):
    for k, v in spellings.items():
        text = text.replace(k, v)
    return text

def get_wikimedia_image(query):
    return f"https://placehold.co/400x400/2C3E50/FFFFFF?text={urllib.parse.quote(query)}"

with codecs.open('lib/data.dart', 'r', 'utf-8') as f:
    dart_code = f.read()

menu_match = re.search(r'final List<MenuItemModel> INITIAL_MENU = \[(.*?)\];', dart_code, re.DOTALL)
if not menu_match:
    print("Could not find INITIAL_MENU")
    exit(1)

menu_items_text = menu_match.group(1)
output_lines = []
seen = set()

for line in menu_items_text.splitlines():
    line = line.strip()
    if not line: continue
    
    m = re.search(r'id:"([^"]+)".*?nameKu:"([^"]+)".*?nameAr:"([^"]+)".*?price:(\d+).*?cat:"([^"]+)"', line)
    if not m:
        continue
    
    id, nameKu, nameAr, price, cat = m.groups()
    
    if "milk" in nameKu.lower() or "شیر" in nameKu:
        continue
        
    en_name, search_query = query_map.get(nameKu, ("Unknown", nameKu))
    
    nameKu = fix_spelling(nameKu)
    nameAr = fix_spelling(nameAr)
    
    if "تارێک" in nameKu:
        if "تارێک" in seen:
            continue
        seen.add("تارێک")
        
    image_url = get_wikimedia_image(search_query)
    
    new_obj = f'''  MenuItemModel(
    id: "{id}",
    categoryId: "{cat}",
    nameKu: "{nameKu}",
    nameAr: "{nameAr}",
    nameEn: "{en_name}",
    priceIQD: {price}.0,
    imageSearchQuery: "{search_query}",
    imageUrl: "{image_url}",
    isAvailable: true,
  ),'''
    output_lines.append(new_obj)

new_array = "[\n" + "\n".join(output_lines) + "\n]"
new_dart_code = dart_code[:menu_match.start()] + f"final List<MenuItemModel> INITIAL_MENU = {new_array};" + dart_code[menu_match.end():]

with codecs.open('lib/data.dart', 'w', 'utf-8') as f:
    f.write(new_dart_code)
print("Done!")
