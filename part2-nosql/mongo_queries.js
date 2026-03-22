// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    "_id": "PROD_ELEC_001",
    "name": "Sony Noise-Cancelling Headphones",
    "category": "Electronics",
    "price": 25000,
    "brand": "Sony",
    "specifications": { "voltage": "5V", "warranty_months": 12, "battery_life_hours": 30 },
    "features": ["Bluetooth 5.0", "Active Noise Cancellation", "Built-in Mic"]
  },
  {
    "_id": "PROD_CLO_001",
    "name": "Men's Classic Denim Jacket",
    "category": "Clothing",
    "price": 3500,
    "brand": "Levi's",
    "available_sizes": ["S", "M", "L", "XL"],
    "materials": { "cotton": "98%", "elastane": "2%" },
    "care_instructions": "Machine wash cold, tumble dry low"
  },
  {
    "_id": "PROD_GRO_001",
    "name": "Organic Almond Milk",
    "category": "Groceries",
    "price": 320,
    "brand": "Silk",
    "expiry_date": new Date("2024-11-15T00:00:00Z"),
    "is_organic": true,
    "nutritional_info": { "calories_per_100ml": 15, "protein_grams": 0.5, "sugar_grams": 0 },
    "dietary_tags": ["Vegan", "Dairy-Free", "Gluten-Free"]
  }
]);

// OP2: find() — retrieve all Electronics products with price > 20000
db.products.find({
    category: "Electronics",
    price: { $gt: 20000 }
});

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
db.products.find({
    category: "Groceries",
    expiry_date: { $lt: new Date("2025-01-01T00:00:00Z") }
});

// OP4: updateOne() — add a "discount_percent" field to a specific product
db.products.updateOne(
    { _id: "PROD_ELEC_001" },
    { $set: { discount_percent: 10 } }
);

// OP5: createIndex() — create an index on category field and explain why
db.products.createIndex({ category: 1 });
/* Explanation: 
Creating an index on the 'category' field drastically improves read performance for our catalog. 
Without it, if a user clicks on the "Electronics" tab, MongoDB has to perform a "collection scan"—meaning 
it checks every single product in the entire database one by one to see if it matches. 
By creating an index, we give MongoDB a sorted roadmap, allowing it to instantly locate and return 
only the items in that specific category without scanning the rest of the database.
*/
