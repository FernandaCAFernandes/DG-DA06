
EXTRAÇÃO:
(1) Importação do dump/backup para um banco de dados Relacional (SQL);
Passo a passo para se fazer um backup no PostgresSQL:
  1 - Criar o database que irar receber o backup
  2 - Click direito no BD + RESTORE
  3 - Preencher com as seguintes informacões : 
            Format: Custom or tar
            Filename: Path to file de backup
  4 - Aguardar o processo de Restore, possivel visualizar na aba Processes

Pronto! C:
Após a execução dos passos acima, finalizado o processo e dado o REFRESH no banco deverá aparecer no Schemas.

(2) Modelagem Lógica do banco de dados importado acima;