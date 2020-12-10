import os
import argparse
import datetime

today = datetime.date.today()
parser = argparse.ArgumentParser()
parser.add_argument('dbname', metavar='Database Name', help='Target database name')
parser.add_argument('location', metavar='Backup Location', help='Target database backup location ')
args = parser.parse_args()
db = args.dbname
location = args.location

def DB_Backup():
        sql = "su - postgres -c 'pg_dump  -U postgres  -b -E UTF-8  {0} -f {1}-{2}.sql'".format(db,location,today)
        os.system(sql)


def main():

        DB_Backup()


if __name__ == '__main__':
        main()
