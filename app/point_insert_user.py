import os
import psycopg2


def insert(id_funcionario, email):
    try:
        print(insert)
        database = {
            'dbname': 'pointdb',
            'user': os.getenv('POINT_DB_USERNAME'),
            'password': os.getenv('POINT_DB_PASSWORD'),
            'host': os.getenv('DB_HOST')
        }
        conn = psycopg2.connect(**database)
        print(conn)
        cursor = conn.cursor()

        query = """INSERT INTO public.funcionario
                    (id_funcionario, email)
                    VALUES(%s, %s);"""

        cursor.execute(query, (id_funcionario, email))

        conn.commit()
        cursor.close()
        conn.close()

    except Exception as e:
        print(f"Erro: {e}")
        raise e
