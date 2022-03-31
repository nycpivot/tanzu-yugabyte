using System;
using System.Threading;
using Npgsql;

namespace yugabyte_reader
{
    class Program
    {
        static void Main(string[] args)
        {
            NpgsqlConnection conn = new NpgsqlConnection("host=ab75cc4eb4f6843e9af733f64362db0d-1135999124.us-east-2.elb.amazonaws.com;port=5433;database=tanzu_yugabyte_dotnet;user id=yugabyte;password=");

            try
            {
                conn.Open();

                Console.Write("Press Enter to continue...");
                Console.ReadLine();

                Console.WriteLine("ID\tNAME\t\t\t\tAGE");

                for (int index = 1; index < 1000000; index++)
                {
                    NpgsqlCommand empPrepCmd = new NpgsqlCommand($"SELECT id, name, age, language FROM employee WHERE id = @EmployeeId", conn);
                    empPrepCmd.Parameters.Add("@EmployeeId", NpgsqlTypes.NpgsqlDbType.Integer);

                    empPrepCmd.Parameters["@EmployeeId"].Value = index;

                    using (NpgsqlDataReader reader = empPrepCmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            try
                            {
                                var id = reader.GetInt32(0);
                                var name = reader.GetString(1);
                                var age = reader.GetInt32(2);

                                Console.WriteLine($"{id}\t{name}\t\t\t\t{age}");

                                Thread.Sleep(500);
                            }
                            catch (Exception ex)
                            {
                                Console.WriteLine("ERROR: " + ex.Message);

                                if (conn.State == System.Data.ConnectionState.Closed)
                                {
                                    conn.Open();
                                }
                            }
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
    }
}
