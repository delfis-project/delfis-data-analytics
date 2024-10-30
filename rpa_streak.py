import pandas as pd
import psycopg2 as ps
from psycopg2 import sql
import datetime
from sqlalchemy import create_engine
from os import getenv
from dotenv import load_dotenv

load_dotenv()

# Parâmetros de conexão com o banco de dados
conn_params_source = {
    "dbname": getenv("DBNAME_INSERCAO"),
    "user": getenv("USER_INSERCAO"),
    "host": getenv("HOST_INSERCAO"),
    "password": getenv("PASSWORD_INSERCAO"),
    "port": getenv("PORT_INSERCAO")
}

# Conexão usando SQLAlchemy
engine = create_engine(f"postgresql+psycopg2://{conn_params_source['user']}:{conn_params_source['password']}@{conn_params_source['host']}:{conn_params_source['port']}/{conn_params_source['dbname']}")

user_table = "app_user"
streak_table = "streak"

try:
    # Carregar os dados da tabela de usuários
    day_last_log = pd.read_sql(f"SELECT id, updated_at FROM {user_table}", engine)

    # Conectar ao banco de dados com psycopg2
    conn = ps.connect(**conn_params_source)
    cur = conn.cursor()

    for i in range(len(day_last_log)):
        last_log_date = day_last_log['updated_at'][i]
        user_id = int(day_last_log['id'][i])  # Convert to native int if necessary

        # Verifica se o usuário não fez login nas últimas 24 horas
        if last_log_date < datetime.datetime.now() - datetime.timedelta(days=1):
            update_query = f"""
            UPDATE {streak_table} 
            SET final_date = %s 
            WHERE fk_app_user_id = %s 
            AND final_date IS NULL
            """
            # Executa a query de atualização
            cur.execute(update_query, (last_log_date, user_id))

    # Commit das alterações
    conn.commit()
    print("Alterações feitas!")

except Exception as e:
    print(f"Erro ao carregar dados da tabela {user_table}: {e}")

finally:
    # Fechar a conexão com o banco de dados
    if conn:
        conn.close()
