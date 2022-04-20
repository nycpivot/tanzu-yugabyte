using Microsoft.AspNetCore.Mvc;
using Npgsql;
using System;
using Tanzu.Yugabyte.Api.Models;

namespace Tanzu.Yugabyte.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeesController : ControllerBase
    {
        [HttpGet]
        public Employee Post()
        {
            var host = Environment.GetEnvironmentVariable("hostname");
            var database = Environment.GetEnvironmentVariable("yugabyte");
            var user = Environment.GetEnvironmentVariable("yugabyte");

            NpgsqlConnection conn = new NpgsqlConnection($"host={host};port=5433;database={database};user id={user};password=");

            var employee = new Employee();

            try
            {
                conn.Open();

                NpgsqlCommand maxCmd = new NpgsqlCommand("SELECT MAX(id) FROM employee", conn);
                var max = maxCmd.ExecuteScalar();

                int count = 1;
                if (max != DBNull.Value)
                {
                    count = Convert.ToInt32(max) + 1;
                }

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

                var sql = $"INSERT INTO employee (id, name, age, language) VALUES ({count}, '{name}', {age}, '{lang}');";

                employee.Id = count;
                employee.Name = name;
                employee.Age = age;

                NpgsqlCommand empInsertCmd = new NpgsqlCommand(sql, conn);
                int numRows = empInsertCmd.ExecuteNonQuery();
            }
            finally
            {
                if (conn.State != System.Data.ConnectionState.Closed)
                {
                    conn.Close();
                }
            }

            return employee;
        }

        [HttpGet]
        public Employee Get(int id)
        {
            var host = Environment.GetEnvironmentVariable("hostname");
            var database = Environment.GetEnvironmentVariable("yugabyte");
            var user = Environment.GetEnvironmentVariable("yugabyte");

            NpgsqlConnection conn = new NpgsqlConnection($"host={host};port=5433;database={database};user id={user};password=");

            var employee = new Employee();

            try
            {
                conn.Open();

                NpgsqlCommand empPrepCmd = new NpgsqlCommand($"SELECT id, name, age, language FROM employee WHERE id = @EmployeeId", conn);
                empPrepCmd.Parameters.Add("@EmployeeId", NpgsqlTypes.NpgsqlDbType.Integer);

                empPrepCmd.Parameters["@EmployeeId"].Value = id;

                using (NpgsqlDataReader reader = empPrepCmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        employee.Id = reader.GetInt32(0);
                        employee.Name = reader.GetString(1);
                        employee.Age = reader.GetInt32(2);
                    }
                }
            }
            finally
            {
                if (conn.State != System.Data.ConnectionState.Closed)
                {
                    conn.Close();
                }
            }

            return employee;
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
