## Anomaly Analysis

Looking through the `orders_flat.csv` file, you can clearly see the headaches that come from jamming all our data into one massive table. Here are three specific issues I found:

* **Insert Anomaly:** Right now, there is no way to add a brand new product to our system unless a customer actually buys it first. If we get a new inventory item, we can't record its ID, name, or price without making up a fake order and fake customer to go with it.
* **Update Anomaly:** We have a ton of repeated data. [cite_start]Take the "Pen Set" (P007) for example; it shows up over and over again in different orders[cite: 1, 2, 4]. If the price of that pen set goes up, we have to find and update every single row where it was sold. If we miss even one, our financial reporting will be messed up.
* **Delete Anomaly:** We can accidentally lose important data just by clearing out an old order. [cite_start]For instance, customer C003 ordered a Webcam (P008) in order ORD1185[cite: 2]. That is the only time the webcam appears in the entire dataset. If that order gets canceled and we delete the row, the database completely forgets that the Webcam product ever existed.

## Normalization Justification

I understand why the flat file format seems appealing to management at first glance—it looks just like a familiar Excel spreadsheet where you can see everything at once. But treating a relational database like a spreadsheet is a terrible idea for long-term stability.

The biggest issue with the current setup is massive data duplication. Look at our sales reps; [cite_start]Deepak Joshi's name, email, and full Mumbai office address are repeated across dozens of individual rows[cite: 1, 2, 3]. That is a huge waste of storage. Worse, if Deepak moves to a different office, we have to run a massive update across all his historical orders just to fix his address. 

By normalizing this into Third Normal Form (3NF) and splitting it into `Customers`, `Products`, `Sales_Reps`, and `Orders` tables, we solve this completely. We only store Deepak's address exactly once in the `Sales_Reps` table. If he moves, we update one single cell, and the entire database is instantly accurate. Normalization isn't over-engineering; it's the bare minimum requirement to make sure our data doesn't become a tangled, inaccurate mess as the business grows.
