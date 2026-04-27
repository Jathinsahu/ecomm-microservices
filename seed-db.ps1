# Seed categories and products directly into MongoDB Atlas
# Uses mongosh (MongoDB Shell) 

$CATEGORY_URI = "mongodb+srv://jnexusadmin:jnexusadmin@cluster0.q6nnoki.mongodb.net/js_category_service"
$PRODUCT_URI  = "mongodb+srv://jnexusadmin:jnexusadmin@cluster0.q6nnoki.mongodb.net/js_product_service"

Write-Host "Seeding Categories..." -ForegroundColor Cyan

$categoryScript = @'
db.categories.deleteMany({});
var smartphones = db.categories.insertOne({ categoryName: "Smartphones", description: "Latest smartphones and mobile devices", imageUrl: "https://m.media-amazon.com/images/I/61bX2AoGj6L.jpg" });
var audio = db.categories.insertOne({ categoryName: "Audio & Wearables", description: "Earbuds, headphones and smart watches", imageUrl: "https://m.media-amazon.com/images/I/61Mv3cWzZeL.jpg" });
var gaming = db.categories.insertOne({ categoryName: "Gaming", description: "Gaming consoles and accessories", imageUrl: "https://www.shopitree.com/cdn/shop/files/Slim-Digital-E-Chassis_1500x1500.jpg?v=1761798198" });
print("smartphones_id=" + smartphones.insertedId);
print("audio_id=" + audio.insertedId);
print("gaming_id=" + gaming.insertedId);
'@

$catOutput = $categoryScript | mongosh $CATEGORY_URI --quiet 2>&1
Write-Host $catOutput -ForegroundColor Gray

# Extract IDs from output
$smartphoneId = ($catOutput | Select-String "smartphones_id=(.+)").Matches.Groups[1].Value.Trim()
$audioId      = ($catOutput | Select-String "audio_id=(.+)").Matches.Groups[1].Value.Trim()
$gamingId     = ($catOutput | Select-String "gaming_id=(.+)").Matches.Groups[1].Value.Trim()

Write-Host ""
Write-Host "Category IDs:" -ForegroundColor Yellow
Write-Host "  Smartphones : $smartphoneId"
Write-Host "  Audio       : $audioId"
Write-Host "  Gaming      : $gamingId"
Write-Host ""
Write-Host "Seeding Products..." -ForegroundColor Cyan

$productScript = @"
db.products.deleteMany({});
db.products.insertMany([
  { productName: "Samsung S25 Ultra", price: 129999, description: "Samsung Galaxy S25 Ultra with 200MP camera, S-Pen, and Snapdragon 8 Elite processor.", imageUrl: "https://rukmini1.flixcart.com/image/1500/1500/xif0q/mobile/d/0/x/-original-imahhyzrnhgzvdk4.jpeg?q=70", categoryId: "$smartphoneId", categoryName: "Smartphones" },
  { productName: "iPhone 15 Pro Max", price: 159999, description: "Apple iPhone 15 Pro Max with A17 Pro chip, titanium design, and 48MP main camera.", imageUrl: "https://bnewmobiles.com/cdn/shop/files/71MXmswILHL._SL1500.jpg?v=1765518813", categoryId: "$smartphoneId", categoryName: "Smartphones" },
  { productName: "Samsung Galaxy S24 FE", price: 54999, description: "Samsung Galaxy S24 FE with 6.7-inch display, 50MP camera, and Galaxy AI features.", imageUrl: "https://api.thechennaimobiles.com/1729173113344.jpg", categoryId: "$smartphoneId", categoryName: "Smartphones" },
  { productName: "OnePlus 13", price: 69999, description: "OnePlus 13 with Snapdragon 8 Elite, Hasselblad cameras, and 100W fast charging.", imageUrl: "https://m.media-amazon.com/images/I/71vRZZ+FCiL.jpg", categoryId: "$smartphoneId", categoryName: "Smartphones" },
  { productName: "Samsung Galaxy Buds 2 Pro", price: 17999, description: "Samsung Galaxy Buds 2 Pro with active noise cancellation and Hi-Fi audio.", imageUrl: "https://m.media-amazon.com/images/I/61Mv3cWzZeL.jpg", categoryId: "$audioId", categoryName: "Audio & Wearables" },
  { productName: "Samsung Galaxy Watch Ultra", price: 74999, description: "Samsung Galaxy Watch Ultra with titanium body, advanced health tracking, and 60-hour battery.", imageUrl: "https://images-cdn.ubuy.co.in/66b9d92695980247202902d3-samsung-galaxy-watch-ultra-47mm-smart.jpg", categoryId: "$audioId", categoryName: "Audio & Wearables" },
  { productName: "Sony WH-1000XM5", price: 29990, description: "Sony WH-1000XM5 industry-leading noise cancelling wireless headphones.", imageUrl: "https://dailydeals365.in/wp-content/uploads/2023/03/61btxzpfDL._SL1500_.jpg", categoryId: "$audioId", categoryName: "Audio & Wearables" },
  { productName: "Apple AirPods Pro 2", price: 24900, description: "AirPods Pro 2nd Gen with H2 chip, Adaptive Transparency, and up to 30hr battery.", imageUrl: "https://m.media-amazon.com/images/I/61SUj2aKoEL.jpg", categoryId: "$audioId", categoryName: "Audio & Wearables" },
  { productName: "PlayStation 5 Slim", price: 54990, description: "PlayStation 5 Slim Digital Edition with ultra-high-speed SSD and DualSense controller.", imageUrl: "https://www.shopitree.com/cdn/shop/files/Slim-Digital-E-Chassis_1500x1500.jpg?v=1761798198", categoryId: "$gamingId", categoryName: "Gaming" },
  { productName: "Xbox Series X", price: 52999, description: "Xbox Series X — the fastest, most powerful Xbox ever with 4K gaming and 120 FPS.", imageUrl: "https://m.media-amazon.com/images/I/61-jjE67uqL.jpg", categoryId: "$gamingId", categoryName: "Gaming" }
]);
print("Done: " + db.products.countDocuments() + " products inserted.");
"@

$prodOutput = $productScript | mongosh $PRODUCT_URI --quiet 2>&1
Write-Host $prodOutput -ForegroundColor Gray

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Seeding Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
