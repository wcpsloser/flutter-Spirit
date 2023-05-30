const express = require('express');
const mysql = require('mysql2');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended: false}));

// Setup database
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "123456789",
  database: "store_app"
});

db.connect(err => {
  if (err) throw(err);
  else console.log("Database is connected");
});

const queryDB = (sql) => {
  return new Promise((resolve, reject) => {
    db.query(sql, (err, result, fields) => {
      if (err) reject(err);
      else resolve(result);
    });
  });
}

//? CRUD Product table
const productTable = "products";

// CREATE - Add a new product
app.post("/product", async (req, res) => {
  let sql = "CREATE TABLE IF NOT EXISTS " + productTable + " (id INT AUTO_INCREMENT PRIMARY KEY, name VARCHAR(100) NOT NULL, description TEXT, price DECIMAL(10, 2) NOT NULL, stock INT DEFAULT 0)";
  await queryDB(sql);
  
  const { name, description, price, stock } = req.body;
  sql = "INSERT INTO " + productTable + " (name, description, price, stock) VALUES ('" + name + "', '" + description + "', " + price + ", " + stock + ")";
  await queryDB(sql);
  
  console.log("New product created successfully");
  res.json({message: "New product created successfully"});
});

// READ - Get all product
app.get("/product", async (req, res) => {
  let sql = "SELECT * FROM " + productTable;
  let result = await queryDB(sql);
  
  console.log("Get products successfully");
  res.json(result);
});

// UPDATE - Update a specific product
app.put("/product/:id", async (req, res) => {
  const { name,img, description, price, stock } = req.body;
  const id = req.params.id;

  let sql = "UPDATE " + productTable + " SET name = '" + name +"', img ='"+img +"', description = '" + description + "', price = " + price + ", stock = " + stock + " WHERE id = " + id;
  await queryDB(sql);

  console.log("Product updated successfully");
  res.json({message: "Product updated successfully"});
});

// DELETE - Delete a specific product
app.delete("/product/:id", async (req, res) => {
  const id = req.params.id;
  
  let sql = "DELETE FROM " + productTable + " WHERE id = " + id;
  await queryDB(sql);
  
  console.log("Product deleted successfully");
  res.json({message: "Product deleted successfully"});
});

//? CRUD Order table
const orderTable = "orders";

// CREATE - Add a order
app.post("/order", async (req, res) => {
  let sql = "CREATE TABLE IF NOT EXISTS " + orderTable + " (id INT AUTO_INCREMENT PRIMARY KEY, user_id INT NOT NULL, product_id INT NOT NULL, quantity INT NOT NULL DEFAULT 1, status VARCHAR(100) NOT NULL, FOREIGN KEY (user_id) REFERENCES " + userTable + "(id), FOREIGN KEY (product_id) REFERENCES " + productTable + "(id))";
  await queryDB(sql);
  
  const { user_id, product_id, quantity, status } = req.body;
  sql = "INSERT INTO " + orderTable + " (user_id, product_id, quantity, status) VALUES (" + user_id + ", " + product_id + ", " + quantity + ", '" + status + "')";
  await queryDB(sql);
  
  console.log("New order created successfully");
  res.json({message: "New order created successfully"});
});

// READ - Get all order
app.get("/order", async (req, res) => {
  let sql = "SELECT * FROM " + orderTable;
  let result = await queryDB(sql);
  
  console.log("Get orders successfully");
  res.json(result);
});

// UPDATE - Update a specific order
app.put("/order/:id", async (req, res) => {
  const { user_id, product_id, quantity, status } = req.body;
  const id = req.params.id;
  
  let sql = "UPDATE " + orderTable + " SET user_id = " + user_id + ", product_id = " + product_id + ", quantity = " + quantity + ", status = '" + status + "' WHERE id = " + id;
  console.log(sql);
  await queryDB(sql);

  console.log("Order updated successfully");
  res.json({message: "Order updated successfully"});
});

// DELETE - Delete a specific order
app.delete("/order/:id", async (req, res) => {
  const id = req.params.id;
  
  let sql = "DELETE FROM " + orderTable + " WHERE id = " + id;
  await queryDB(sql);
  
  console.log("Order deleted successfully");
  res.json({message: "Order deleted successfully"});
});

//? CRUD User table
const userTable = "users";

// CREATE - Add a user
app.post("/user", async (req, res) => {
  let sql = "CREATE TABLE IF NOT EXISTS " + userTable + " (id INT AUTO_INCREMENT PRIMARY KEY, fullname TEXT, username VARCHAR(100) NOT NULL, password VARCHAR(100) NOT NULL)";
  await queryDB(sql);
  
  const { fullname, username, password } = req.body;
  sql = "INSERT INTO " + userTable + " (fullname, username, password) VALUES ('" + fullname + "', '" + username + "', '" + password + "')";
  await queryDB(sql);
  
  console.log("New user created successfully");
  res.json({message: "New user created successfully"});
});

// READ - Get all user
app.get("/user", async (req, res) => {
  let sql = "SELECT * FROM " + userTable;
  let result = await queryDB(sql);
  
  console.log("Get users successfully");
  res.json(result);
});

// Start the server
const port = 3000;

app.listen(port, () => {
  console.log('Server started on port ' + port);
});
