import os, time
import pymssql

def check():
    conn = pymssql.connect(
        server=os.environ["DW_HOST"],
        database=os.environ["DW_DATABASE"],
        user=os.environ["DW_USER"],
        password=os.environ["DW_PASSWORD"],
    )
    cur = conn.cursor()
    cur.execute("SELECT TOP 10 TABLE_SCHEMA, TABLE_NAME FROM INFORMATION_SCHEMA.TABLES")
    for row in cur.fetchall():
        print(row, flush=True)
    conn.close()
    print("WAREHOUSE CONNECTION OK", flush=True)

if __name__ == "__main__":
    check()
    time.sleep(999999)  # stay alive so we can exec in for interactive work