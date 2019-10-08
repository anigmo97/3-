using GestDepLib.Persistence;
using GestDepLib.Entities;
using System.Linq;
using GestDepLib;
using System;
using System.Data.Entity;
using System.Text;
using System.Collections.Generic;

namespace GestDep.Testing
{
    class DBTest
    {
        
        
        static void Main(string[] args)
        {
           IDAL dal = new EntityFrameworkDAL(new GestDepDbContext());
           populateDB(dal);
           displayData(dal);
        }

        private static void populateDB(IDAL dal)
        {
            // Remove all data from DB
            dal.Clear<Course>();
            dal.Clear<Monitor>();
            dal.Clear<Person>();
            dal.Clear<User>();
            dal.Clear<Payment>();
            dal.Clear<Enrollment>();
            dal.Clear<Lane>();
            dal.Clear<Pool>();
            Pool p = new Pool(new DateTime(2017, 10, 20, 8, 0, 0),
                new DateTime(2017, 10, 20, 21, 0, 0),
                46122, 1, 20, 15, 3.0f);

            dal.Insert<Pool>(p);

            
            Lane l2 = new Lane(2);
            p.Lanes.Add(l2);
            dal.Insert(l2);
            Lane l3 = new Lane(3);
            p.Lanes.Add(l3);
            dal.Insert(l3);
            Lane l4 = new Lane(4);
            p.Lanes.Add(l4);
            dal.Insert(l4);
            Lane l5 = new Lane(5);
            p.Lanes.Add(l5);
            dal.Insert(l5);
            Lane l6 = new Lane(6);
            p.Lanes.Add(l6);
            dal.Insert(l6);


            Course c1 = new Course(false, Days.Monday | Days.Wednesday | Days.Friday,
               "Learning with M.Phelp", new TimeSpan(0, 45, 0), new DateTime(2018, 6, 29),
               20, 6, 100.0,
               new DateTime(2017, 11, 6), new DateTime(2017, 1, 1, 9, 30, 0) );
            Lane l1 = new Lane(1);
            p.Lanes.Add(l1);
            dal.Insert(l1);

            c1.Lanes.Add(l1);
            c1.Lanes.Add(l2);
            dal.Insert<Course>(c1);



            User p1 = new User( new DateTime(1990, 06, 05), false, "Ona Carbonell's address", "ES891234121234567890",  "1234567890", "Ona Carbonell",46002);
            dal.Insert<Person>(p1);
           User p2 = new User(new DateTime(1977, 04, 12), false, "Gemma Mengual's address", "ES891234121234567890", "2345678901", "Gemma Mengual" ,46002);
            dal.Insert<Person>(p2);
            User p3 = new User(new DateTime(1990, 11, 10), false,"Mireia Belmonte's address", "ES891234121234567890", "3456789012", "Mireia Belmonte", 46002);
           dal.Insert<Person>(p3);
            User p4 = new User(new DateTime(1995, 02, 28), false, "Rigoberto's address", "ES891234121234567890", "4567890123", "Rigoberto",  46002);
            dal.Insert<Person>(p4);
            User p5 = new User(new DateTime(1972, 01, 01), true,"Lázaro's address", "ES891234121234567890", "5678901234", "Lázaro",46002);
            dal.Insert<Person>(p5);
            Monitor p6 = new Monitor("SSN01010101","Michael Phelp's address", "ES891234121234567890", "X-00000001", "Michael Phelp", 46002);
            dal.Insert<Person>(p6);
            c1.Monitor = p6;
            c1.Monitor = p6;
            dal.Commit();



            Course c2 = new Course(false, Days.Tuesday | Days.Thursday,
                "Swimming for dummies", new TimeSpan(1, 0, 0),
                new DateTime(2018, 6, 29), 16, 8, 75, new DateTime(2017, 11, 7), 
                new DateTime(2017, 1, 1, 19, 0, 0) );
            c2.Lanes.Add(l3);


            dal.Insert<Course>(c2);


            Payment pa1 = new Payment(new DateTime(2017, 8, 10), "Free swim", 3.0);
            dal.Insert<Payment>(pa1);
            Payment pa2 = new Payment(new DateTime(2017, 8, 20), "Free swim", 3.0);
            dal.Insert<Payment>(pa2);
            Payment pa3 = new Payment(new DateTime(2017, 8, 20), "Free swim", 3.0);
            dal.Insert<Payment>(pa3);
            Payment pa4 = new Payment(new DateTime(2017, 8, 16), "First monthly quota-learning with M.Phelps", 100.0);
            dal.Insert<Payment>(pa4);
            Payment pa5 = new Payment(new DateTime(2017, 8, 26), "First monthly quota-learning with M.Phelps",100.0);
            dal.Insert<Payment>(pa5);
            Payment pa6 = new Payment(new DateTime(2017, 8, 28), "First monthly quota-learning with M.Phelps", 100.0);
            dal.Insert<Payment>(pa6);
            Payment pa7 = new Payment(new DateTime(2017, 8, 28), "Fist monthly quota - Swimming for dummiys", 75.0);
            dal.Insert<Payment>(pa7);
             Payment pa8 = new Payment(new DateTime(2017, 9, 04), "Fist monthly quota - Swimming for dummiys", 75.0);
            dal.Insert<Payment>(pa8);

            Enrollment en1 = new Enrollment(null, new DateTime(2017, 8, 16), null,pa1, p1, c1);
            dal.Insert<Enrollment>(en1);
            c1.Enrollments.Add(en1);
            Enrollment en2 = new Enrollment(null, new DateTime(2017, 7, 26), null, pa2, p2,c1);
            dal.Insert<Enrollment>(en2);
            c1.Enrollments.Add(en2);
            Enrollment en3 = new Enrollment(null, new DateTime(2017, 8, 28), null, pa3, p3,c1);
            dal.Insert<Enrollment>(en3);
            c1.Enrollments.Add(en3);
            Enrollment en4 = new Enrollment(new DateTime(2017, 10, 20), new DateTime(2017, 8, 28), null, pa3, p4,c2);
            dal.Insert<Enrollment>(en4);
            c2.Enrollments.Add(en4);
            Enrollment en5 = new Enrollment(new DateTime(2017, 10, 20), new DateTime(2017, 9, 4), null, pa4, p5,c2);
            dal.Insert<Enrollment>(en5);
            c2.Enrollments.Add(en5);





            dal.Commit();

            // Populate the database with the data described in lab 4 bulletin (see Apendix)


        }

        private static void displayData(IDAL dal)
        {
            Pool pool = dal.GetAll<Pool>().First();
            foreach (Course course in dal.GetAll<Course>())
            {
                Console.WriteLine("===================================");
                Console.WriteLine("         Course details         ");
                Console.WriteLine("===================================");
                Console.WriteLine(CourseToString(course));
                //foreach (Days day in Enum.GetValues(typeof(Days)))
                //{
                //    if ((course.CourseDays & day) == day)
                //        Console.WriteLine("Course on " + day.ToString());
                //}
            }
            Console.WriteLine("Payments:");
            foreach (Payment pay in dal.GetAll<Payment>())
                Console.Write(PaymentToString(pay));
            Console.WriteLine("Pres Key to exit...");
            Console.ReadKey();
        }

        public static String PersonToString(Person person)
        {
            return (person.Name + " (" + person.Id + ")");
            
        }

        public static String CourseToString(Course course)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("StartDate: " + course.StartDate);
            sb.AppendLine("FinishDate: " + course.FinishDate);
            sb.AppendLine("Days : " + course.CourseDays);
            sb.AppendLine("Price: " + course.Price);
            sb.AppendLine("Lanes assigned: ");
            foreach (Lane lane in course.Lanes)
                sb.AppendLine(" Lane " + lane.Number);
            if (course.Monitor != null)
                sb.AppendLine("\nUsers enrolled in course " + course.Description + ", with monitor " + PersonToString(course.Monitor));
            else sb.AppendLine("\nUsers enrolled in course " + course.Description + ", with no monitor yet");
            foreach (Enrollment en in course.Enrollments)
            {
                sb.Append(" " + EnrollmentToString(en));
            }
            //sb.AppendLine("");
            return sb.ToString();
        }

        public static String EnrollmentToString(Enrollment en)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine(PersonToString(en.User) + " enrolled on " + en.EnrollmentDate);
            return sb.ToString();
        }

        public static String PaymentToString(Payment pay)
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine(" " + pay.Date + " -> " + pay.Description + ": " + pay.Quantity);
            return sb.ToString();
        }


        private static DateTime createTime(int hours, int minutes, int seconds)
        {
            DateTime now = DateTime.Now;
            return new DateTime(now.Year, now.Month, now.Day, hours, minutes, seconds);
        }

    }
}
