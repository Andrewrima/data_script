import psycopg2

conn_data = dict(host='192.168.254.13', user="postgres",
                 password="PASSWORD", dbname="db_Teste")

try:
    conn = psycopg2.connect(**conn_data)
    cur = conn.cursor()
    cur.execute("SELECT pid, usename, query, state FROM pg_stat_activity WHERE state ILIKE 'idle' AND query NOT ILIKE '%pg_stat_activity%'")

    resultado = cur.fetchall()

    if resultado:
        for res in resultado:
            res = res[0]
            res = str(res)
            cur.execute(f"SELECT pg_terminate_backend({res})")
            conn.commit()
        print("Conexões IDLE fechadas!")

except:
    pass

finally:
    try:
        cur.close()
        conn.close()
    except:
        pass
