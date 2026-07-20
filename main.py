import os, time
import pymssql
from flask import Flask, jsonify

app = Flask(__name__)

def get_db_connection():
    """Create and return a database connection"""
    return pymssql.connect(
        server=os.environ["DW_HOST"],
        database=os.environ["DW_DATABASE"],
        user=os.environ["DW_USER"],
        password=os.environ["DW_PASSWORD"],
    )

def check():
    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute("SELECT TOP 10 TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES")
    for row in cur.fetchall():
        print(row, flush=True)
    conn.close()
    print("WAREHOUSE CONNECTION OK", flush=True)

@app.route('/api/table-row-counts', methods=['GET'])
def get_table_row_counts():
    """Get row count for all tables in the database"""
    try:
        conn = get_db_connection()
        cur = conn.cursor()
        
        # Query to get row counts for all tables
        query = """
        SELECT 
            SCHEMA_NAME(s.schema_id) as SchemaName,
            t.name as TableName,
            SUM(p.rows) as RowCount
        FROM 
            sys.tables t
            INNER JOIN sys.partitions p ON t.object_id = p.object_id
            INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        WHERE 
            p.index_id IN (0, 1)
        GROUP BY 
            s.schema_id, t.name
        ORDER BY 
            SchemaName, TableName
        """
        
        cur.execute(query)
        rows = cur.fetchall()
        conn.close()
        
        # Format results as list of dictionaries
        table_counts = [
            {
                "schema": row[0],
                "table_name": row[1],
                "row_count": row[2]
            }
            for row in rows
        ]
        
        return jsonify({
            "status": "success",
            "tables": table_counts,
            "total_tables": len(table_counts)
        })
    
    except Exception as e:
        return jsonify({
            "status": "error",
            "message": str(e)
        }), 500

if __name__ == "__main__":
    check()
    app.run(host="0.0.0.0", port=5000, debug=False)