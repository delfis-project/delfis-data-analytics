import pandas as pd
import joblib
from flask import Flask, render_template, request
from sqlalchemy import create_engine, Table, Column, Integer, String, MetaData
import os
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Database configuration
DB_HOST = os.getenv('DB_AI_HOST')
DB_USER = os.getenv('DB_AI_USER')
DB_PASSWORD = os.getenv('DB_AI_PASSWORD')
DB_NAME = os.getenv('DB_AI_DATABASE')
DB_PORT = os.getenv('DB_AI_PORT')

# Create the database engine for PostgreSQL
engine = create_engine(f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

# Flask app setup
ROOT_DIR = os.path.dirname(__file__)
app = Flask(__name__)

model_path = os.path.join(ROOT_DIR, 'pipeline.pkl')
pipeline_carregado = joblib.load(model_path)

# Define the home route
@app.route('/', methods=['GET', 'POST'])
def home():
    if request.method == 'POST':
        # Capture form inputs
        faixa_etaria = request.form['faixa_etaria']
        estado = request.form['estado']
        renda = request.form['renda']
        familiaridade = request.form['familiaridade']
        tempo_celular = request.form['tempo_celular']
        interesse_jogos = request.form['interesse_jogos']

        # Prepare input for model prediction
        input_features = pd.DataFrame([{
            'Qual a sua faixa etária?': faixa_etaria,
            'Em qual estado você mora?': estado,
            'Qual sua faixa de renda familiar?': renda,
            'Qual é o seu nível de familiaridade com o uso de aplicativos em dispositivos móveis?': familiaridade,
            'Em média, quanto tempo você usa o celular diariamente?': tempo_celular,
            'Você se interessaria em jogar palavra cruzada, sudoku ou jogos similares a esses diariamente?': interesse_jogos
        }])

        prediction = pipeline_carregado.predict(input_features)

        # Save data and prediction to database
        try:
            with engine.connect() as connection:
                metadata = MetaData()
                predictions_table = Table(
                    'predictions', metadata,
                    Column('id', Integer, primary_key=True, autoincrement=True),
                    Column('faixa_etaria', String(50)),
                    Column('estado', String(50)),
                    Column('renda', String(50)),
                    Column('familiaridade', String(50)),
                    Column('tempo_celular', String(50)),
                    Column('interesse_jogos', String(50)),
                    Column('prediction', String(50))
                )
                metadata.create_all(engine)  # Creates the table if it doesn't exist

                # Insert data without specifying the id
                insert_query = predictions_table.insert().values(
                    faixa_etaria=faixa_etaria,
                    estado=estado,
                    renda=renda,
                    familiaridade=familiaridade,
                    tempo_celular=tempo_celular,
                    interesse_jogos=interesse_jogos,
                    prediction=prediction[0]
                )

                connection.execute(insert_query)
                connection.commit()  # Ensure to commit the transaction
                print("Data inserted successfully.")

                # Query the database to retrieve the latest entries
                df = pd.read_sql("SELECT * FROM predictions ORDER BY id DESC LIMIT 10", connection)
                print(df)  # Print the DataFrame to the console

        except Exception as e:
            print(f"Error inserting data: {e}")
            import traceback
            traceback.print_exc()  # This will print the full traceback

        return render_template("prediction.html", prediction=prediction[0])

    return render_template("index.html")

if __name__ == '__main__':
    app.run(host="0.0.0.0", debug=True)