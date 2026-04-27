const { MongoClient } = require('mongodb');

async function updateImages() {
    const uri = "mongodb+srv://jnexusadmin:jnexusadmin@cluster0.q6nnoki.mongodb.net/js_product_service?retryWrites=true&w=majority";
    const client = new MongoClient(uri);

    try {
        await client.connect();
        const database = client.db('js_product_service');
        const products = database.collection('products');

        const updates = [
            {
                name: "Samsung Galaxy S24 FE",
                url: "https://api.thechennaimobiles.com/1729173113344.jpg"
            },
            {
                name: "Sony WH-1000XM5",
                url: "https://dailydeals365.in/wp-content/uploads/2023/03/61btxzpfDL._SL1500_.jpg"
            },
            {
                name: "OnePlus 13",
                url: "https://m.media-amazon.com/images/I/71vRZZ+FCiL.jpg"
            }
        ];

        for (const item of updates) {
            const result = await products.updateOne(
                { productName: item.name },
                { $set: { imageUrl: item.url } }
            );
            console.log(`${item.name}: ${result.matchedCount} matched, ${result.modifiedCount} modified`);
        }

    } finally {
        await client.close();
    }
}

updateImages().catch(console.dir);
