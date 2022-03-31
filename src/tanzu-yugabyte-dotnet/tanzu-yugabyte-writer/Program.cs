using System;
using System.Threading;
using Npgsql;

namespace Yugabyte_CSharp_Demo
{
    class Program
    {
        static void Main(string[] args)
        {
            NpgsqlConnection conn = new NpgsqlConnection("host=ab75cc4eb4f6843e9af733f64362db0d-1135999124.us-east-2.elb.amazonaws.com;port=5433;database=tanzu_yugabyte_dotnet;user id=yugabyte;password=");
            //NpgsqlConnection conn = new NpgsqlConnection("host=a5380cbe7bb894be9a4adfb1b111c6fd-841709826.us-east-2.elb.amazonaws.com;port=5433;database=yugabyte;user id=postgres;password=");

            try
            {
                conn.Open();

                Console.Write("Drop Table (y/n)? ");
                string input = Console.ReadLine();

                if(String.IsNullOrWhiteSpace(input))
                {
                    input = "n";
                }

                int count = 0;
                if (!String.IsNullOrWhiteSpace(input))
                {
                    if(input == "y")
                    {
                        NpgsqlCommand empDropCmd = new NpgsqlCommand("DROP TABLE employee;", conn);
                        empDropCmd.ExecuteNonQuery();

                        Console.WriteLine("DROP TABLE employee");

                        NpgsqlCommand empCreateCmd = new NpgsqlCommand("CREATE TABLE employee (id int PRIMARY KEY, name varchar, age int, language varchar);", conn);
                        empCreateCmd.ExecuteNonQuery();

                        Console.WriteLine("CREATE TABLE employee");
                    }
                    else if(input == "n")
                    {
                        NpgsqlCommand maxCmd = new NpgsqlCommand("SELECT MAX(id) FROM employee", conn);
                        var max = maxCmd.ExecuteScalar();

                        if (max != null)
                        {
                            count = Convert.ToInt32(max) + 1;
                        }
                    }
                }

                Console.WriteLine();
                Console.WriteLine("ID\tNAME\t\t\tAGE");

                for (int index = count; index < 1000000; index++)
                {
                    try
                    {
                        var random1 = new Random();
                        var len1 = random1.Next(3, 10);
                        var firstName = GenerateName(len1);
                        var lastName = GenerateName(len1);

                        var name = $"{firstName} {lastName}";

                        var random2 = new Random();
                        var age = random2.Next(1, 100);

                        var random3 = new Random();
                        var len2 = random3.Next(15, 25);
                        var lang = GenerateName(len2);

                        Thread.Sleep(500);

                        var sql = $"INSERT INTO employee (id, name, age, language) VALUES ({index}, '{name}', {age}, '{lang}');";
                        Console.WriteLine(sql);

                        NpgsqlCommand empInsertCmd = new NpgsqlCommand(sql, conn);
                        int numRows = empInsertCmd.ExecuteNonQuery();
                    }
                    catch(Exception ex)
                    {
                        Console.WriteLine("ERROR: " + ex.Message);

                        if(conn.State == System.Data.ConnectionState.Closed)
                        {
                            conn.Open();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Failure: " + ex.Message);
            }
            finally
            {
                if (conn.State != System.Data.ConnectionState.Closed)
                {
                    conn.Close();
                }
            }
        }

        public static string GenerateName(int len)
        {
            Random r = new Random();
            string[] consonants = { "b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "l", "n", "p", "q", "r", "s", "sh", "zh", "t", "v", "w", "x" };
            string[] vowels = { "a", "e", "i", "o", "u", "ae", "y" };
            string Name = "";
            Name += consonants[r.Next(consonants.Length)].ToUpper();
            Name += vowels[r.Next(vowels.Length)];
            int b = 2; //b tells how many times a new letter has been added. It's 2 right now because the first two letters are already in the name.
            while (b < len)
            {
                Name += consonants[r.Next(consonants.Length)];
                b++;
                Name += vowels[r.Next(vowels.Length)];
                b++;
            }

            return Name;
        }
    }
}
