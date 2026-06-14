# Advanced SQL Server Engineering

Enterprise SQL Server solutions demonstrating advanced data engineering, hierarchical modeling, temporal databases, recursive queries, and metadata management.

---

# Audit History & Time Travel

This project demonstrates SQL Server System-Versioned Temporal Tables for automatic version tracking and historical data retrieval.

## Features

- Audit history
- Change tracking
- Data lineage
- Time travel analysis

### Example

```sql
SELECT *
FROM ObjectMetadata_V
FOR SYSTEM_TIME AS OF '2023-05-09';
```

---

# HierarchyID

Uses SQL Server's native `hierarchyid` data type for efficient tree storage and navigation.

## Capabilities

- Parent lookup
- Descendant search
- Ancestor search
- Tree traversal
- Hierarchical indexing

### Example

```sql
TreePath.IsDescendantOf(...)
```

---

# Technologies

- SQL Server
- T-SQL
- Recursive CTEs
- `hierarchyid`
- System-Versioned Temporal Tables
- Metadata Modeling
- Transitive Closure
- Relational Database Design

---

# Skills Demonstrated

- Advanced SQL Development
- Enterprise Data Modeling
- Healthcare Data Architecture
- Metadata-Driven Design
- Versioned Data Management
- Hierarchical Query Optimization
- Temporal Database Design
- Recursive Algorithms in SQL
- Performance-Oriented Relational Design

---

# Repository Structure

```text
SQL/
│
├── Advanced SQL/
├── Recursive CTE Examples/
├── HierarchyID/
├── Temporal Tables/
├── Metadata Modeling/
├── Query Optimization/
├── Data Warehousing/
└── Enterprise Data Engineering Patterns/
```

---

# About

This repository is part of my enterprise data engineering portfolio and demonstrates production-style SQL Server patterns developed for healthcare, financial services, cloud modernization, AI platforms, and large-scale data integration initiatives.

## Technology Stack

**SQL Server • Azure SQL • Synapse • Databricks • Snowflake • T-SQL • Data Warehousing • ETL • Data Architecture**
