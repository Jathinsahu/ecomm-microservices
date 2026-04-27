const catIds = {
    "Smartphones": "69ec5146ea1bb8752f8752f8",
    "Gaming": "69ec5146ea1bb8752f8752fa",
    "Audio & Wearables": "69ec5146ea1bb8752f8752f9"
};

const products = [
    { productName: "Samsung S25 Ultra", price: 129999, description: "200MP camera, S-Pen, Snapdragon 8 Elite", imageUrl: "https://rukmini1.flixcart.com/image/1500/1500/xif0q/mobile/d/0/x/-original-imahhyzrnhgzvdk4.jpeg?q=70", categoryId: catIds["Smartphones"] },
    { productName: "iPhone 15 Pro Max", price: 159999, description: "A17 Pro chip, titanium, 48MP camera", imageUrl: "https://bnewmobiles.com/cdn/shop/files/71MXmswILHL._SL1500.jpg?v=1765518813", categoryId: catIds["Smartphones"] },
    { productName: "Samsung Galaxy S24 FE", price: 54999, description: "6.7 inch display, 50MP, Galaxy AI", imageUrl: "https://api.thechennaimobiles.com/1729173113344.jpg", categoryId: catIds["Smartphones"] },
    { productName: "OnePlus 13", price: 69999, description: "Snapdragon 8 Elite, Hasselblad cameras, 100W charging", imageUrl: "https://m.media-amazon.com/images/I/71vRZZ+FCiL.jpg", categoryId: catIds["Smartphones"] },
    { productName: "Samsung Galaxy Buds 2 Pro", price: 17999, description: "Active noise cancellation, Hi-Fi audio", imageUrl: "https://m.media-amazon.com/images/I/61Mv3cWzZeL.jpg", categoryId: catIds["Audio & Wearables"] },
    { productName: "Samsung Galaxy Watch Ultra", price: 74999, description: "Titanium body, 60hr battery, health tracking", imageUrl: "https://images-cdn.ubuy.co.in/66b9d92695980247202902d3-samsung-galaxy-watch-ultra-47mm-smart.jpg", categoryId: catIds["Audio & Wearables"] },
    { productName: "Sony WH-1000XM5", price: 29990, description: "Industry-leading noise cancelling wireless headphones", imageUrl: "https://dailydeals365.in/wp-content/uploads/2023/03/61btxzpfDL._SL1500_.jpg", categoryId: catIds["Audio & Wearables"] },
    { productName: "Apple AirPods Pro 2", price: 24900, description: "H2 chip, Adaptive Transparency, 30hr battery", imageUrl: "https://m.media-amazon.com/images/I/61SUj2aKoEL.jpg", categoryId: catIds["Audio & Wearables"] },
    { productName: "PlayStation 5 Slim", price: 54990, description: "Ultra-high-speed SSD, DualSense controller", imageUrl: "https://www.shopitree.com/cdn/shop/files/Slim-Digital-E-Chassis_1500x1500.jpg?v=1761798198", categoryId: catIds["Gaming"] },
    { productName: "Xbox Series X", price: 52999, description: "4K gaming, 120 FPS, fastest Xbox ever", imageUrl: "https://m.media-amazon.com/images/I/61-jjE67uqL.jpg", categoryId: catIds["Gaming"] }
];

async function seed() {
    for (const p of products) {
        try {
            const res = await fetch('http://localhost:9010/admin/product/add', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(p)
            });
            console.log(`Added: ${p.productName} -> ${res.status}`);
        } catch (e) {
            console.error(`Error for ${p.productName}:`, e);
        }
    }
}

seed();
