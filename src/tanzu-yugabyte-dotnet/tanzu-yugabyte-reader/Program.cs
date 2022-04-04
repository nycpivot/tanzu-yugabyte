﻿using System;
using System.Threading;
using Npgsql;

namespace tanzu_yugabyte_reader
{
    class Program
    {
        static void Main(string[] args)
        {
            var host = args[0];
            var database = args[1];
            var user = args[2];


            NpgsqlConnection conn = new NpgsqlConnection($"host={host};port=5433;database={database};user id={user};password=");

            while (true)
            {
                try
                {
                    conn.Open();

                    Console.Write("Press Enter to continue...");
                    Console.ReadLine();
			    Console.WriteLine();

                    var col1 = "ID";
                    var col2 = "NAME";
                    var col3 = "AGE";

                    Console.WriteLine("{0}{1}{2}{3}{4}{5}", "ID", new String(' ', 10 - 2), "NAME", new String(' ', 30 - 4), "AGE", new String(' ', 10 - 3));
                    Console.WriteLine(new String('-', 50));

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

                                    Console.WriteLine("{0}{1}{2}{3}{4}{5}",
                                        id, new String(' ', 10 - id.ToString().Length),
                                        name, new String(' ', 30 - name.Length),
                                        age, new String(' ', 10 - age.ToString().Length));

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
}
