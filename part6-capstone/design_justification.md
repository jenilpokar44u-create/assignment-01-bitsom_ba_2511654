## Storage Systems

To meet the hospital's four distinct goals, a single "one-size-fits-all" database would fail spectacularly. Instead, I designed a polyglot persistence architecture where each storage system is specifically chosen for its unique workload. 

First, for streaming and storing the real-time vitals from ICU devices, I chose a Time-Series Database (like InfluxDB). ICU sensors generate massive volumes of continuous, time-stamped data (heart rate, oxygen levels) every second. Relational databases choke on this kind of high-velocity ingestion, but time-series databases are built specifically to handle massive write loads and query data by time intervals effortlessly.

Second, for allowing doctors to query patient history in plain English, I implemented a Vector Database. Traditional keyword search is useless for medical records because different doctors use different phrasing (e.g., "heart attack" vs. "myocardial infarction"). The vector database stores medical notes as semantic embeddings, allowing an LLM to retrieve the exact relevant history based on the *meaning* of the doctor's question, not just the exact text keywords.

Third, for generating monthly hospital management reports, I selected a traditional Data Warehouse (like Snowflake). Management needs reliable, highly structured reports on bed occupancy and departmental costs. A data warehouse is optimized for these complex, analytical SQL aggregations across structured historical tables.

Finally, to predict patient readmission risk, I incorporated a Data Lake (like Amazon S3). Machine learning models require massive amounts of raw, historical treatment data—including structured lab results and unstructured clinical notes. A data lake provides cheap, scalable storage to hold all of this historical data in its raw format, making it the perfect training ground for our predictive ML algorithms.

## OLTP vs OLAP Boundary

In this hospital architecture, establishing a strict boundary between OLTP (transactional) and OLAP (analytical) systems is critical so that heavy reporting queries don't slow down life-saving real-time systems. 

The OLTP side consists of the primary Electronic Health Record (EHR) database and the Time-Series database handling the live ICU vitals. These systems are optimized for fast, individual writes and real-time operational reads. 

The boundary itself is an event-streaming platform (like Apache Kafka). As data is written to the OLTP systems, Kafka captures those events and pipelines them over to the analytical side. The OLAP side begins at the Data Warehouse, the Vector Database, and the Data Lake. These systems are entirely separate from the live hospital floor. When hospital management runs a massive end-of-month financial report on the warehouse, it uses zero computing power from the live EHR system, ensuring doctors experience no lag while treating patients.

## Trade-offs

The most significant trade-off in this design is architectural complexity. By utilizing a polyglot persistence model (a Time-Series DB, a Vector DB, a Data Warehouse, and a Data Lake), we are gaining optimal performance for every specific task, but we are paying for it with high maintenance overhead. The data engineering team has to monitor and maintain four distinct storage systems and ensure data remains synchronized across all of them without duplication errors.

To mitigate this, I would implement a centralized data orchestration and monitoring tool (like Apache Airflow) to manage the pipelines feeding these databases. Furthermore, as the system matures, we could potentially migrate the Data Warehouse and Data Lake into a unified Data Lakehouse architecture (like Databricks) to reduce the number of distinct platforms we have to manage, blending the ML training and BI reporting layers into one governed space.
