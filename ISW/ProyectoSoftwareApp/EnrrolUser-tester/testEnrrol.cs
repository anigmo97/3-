using GestDepLib.BusinessLogic.Services;
using GestDepLib.Entities;
using GestDepLib.Persistence;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EnrrolUser_tester
{
    class testEnrrol
    {

        static void Main(string[] args)
        {

            try
            {
                IGestDepService service =
                new GestDepService(new EntityFrameworkDAL(new GestDepDbContext()));

                new testEnrrol(service);
            }
            catch (Exception e)
            {
                printError(e);
            }
            Console.WriteLine("test");
            Console.WriteLine("Press any key to continue...");
            Console.ReadKey();
        }
        private IGestDepService service;
            testEnrrol(IGestDepService service)
        {
            this.service = service;
            service.removeAllData();
            Pool p = creaPiscina(3);
            Course c = new Course("curso1", new DateTime(2017, 11, 20),
            new DateTime(2017, 11, 26), new DateTime(2017, 11, 20, 9, 30, 0),
            new TimeSpan(0, 45, 0),
            Days.Monday | Days.Wednesday | Days.Friday,
            6, 20, false, 100);
            c.addLane(p.findLane(1));
            Course c2 = new Course("curso2", new DateTime(2017, 11, 20),
            new DateTime(2017, 11, 26), new DateTime(2017, 11, 20, 9, 30, 0),
            new TimeSpan(0, 45, 0),
            Days.Monday | Days.Wednesday | Days.Friday,
            6, 20, false, 100);
            c2.addLane(p.findLane(2));
            Course c3 = new Course("curso3", new DateTime(2017, 11, 20),
            new DateTime(2017, 11, 26), new DateTime(2017, 11, 20, 9, 30, 0),
            new TimeSpan(0, 45, 0),
            Days.Monday | Days.Wednesday | Days.Friday,
            6, 20, false, 100);
            c3.addLane(p.findLane(3));
            Course c4 = new Course("curso4", new DateTime(2017, 11, 10),
            new DateTime(2017, 11, 20), new DateTime(2017, 11, 20, 9, 30, 0),
            new TimeSpan(0, 45, 0),
            Days.Monday | Days.Wednesday | Days.Friday,
            6, 20, false, 100);
            c4.addLane(p.findLane(1));
            Course c5 = new Course("curso5", new DateTime(2017, 11, 5),
            new DateTime(2017, 11, 7), new DateTime(2017, 11, 20, 9, 30, 0),
            new TimeSpan(0, 45, 0),
            Days.Monday | Days.Wednesday | Days.Friday,
            6, 20, false, 100);
            c5.addLane(p.findLane(2));
            service.addCourse(c);
            service.addCourse(c2);
            service.addCourse(c3);
            service.addCourse(c4);
            service.addCourse(c5);
            Console.WriteLine("creados y añadidos cursos");
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();
            List<Course> cursosActuales = recuperaCursosActuales();
            Console.WriteLine("SE DEBE MOSTRAR c1 , c2 y c3");
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();
            Console.WriteLine("Escribe el dni del usuario que deseas inscribir...\n\n");
            String id = Console.ReadLine();
            User u = service.findUserById(id);
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();
            if (u == null) {
                // User.introduceDatosUsuarioPorTeclado();
                u = new User("2345678901", "Gemma Mengual", "Gemma Mengual's address", 46002, "ES891234121234567890", new DateTime(1977, 4, 12), false);
                service.addUser(u);
                service.saveChanges();
                Console.WriteLine(c.calculaPrecio(u));
                double precio = c.calculaPrecio(u);
                service.enrollUserToCourse(new DateTime(2017, 07, 26), u, c);
                Payment p4 = new Payment(DateTime.Today, "pago", precio);
                Enrollment e = new Enrollment(null, DateTime.Today, null, p4, u, c);
                service.saveChanges();
                service.addPayment(e, DateTime.Today);
                service.saveChanges();
            }
            else {
                
            }
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();
           
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();


        }
        public List<Course> recuperaCursosActuales()
        {
            

            try
            {
                Console.WriteLine("Mostrando cursos Actuales...");
                List<Course> l = service.getCursosActivosYPorEmpezar();
                foreach(Course c in l)
                {
                    Console.WriteLine("Curso " + c.Description + " con fecha de fin " + c.FinishDate);

                }
                return l;

            }
            catch (Exception e)
            {
                printError(e);
                return null;
            }

        }
        public Pool creaPiscina(int numLanes)
        {
            Console.WriteLine();
            Console.WriteLine("Creando piscina con " + numLanes + " lanes...");

            try
            {
                // Pool(int id, DateTime OpeningHour, DateTime ClosingHour, int ZipCode, int discountLocal, int discountRetired, double freeSwimPrice)
                // Id is not autogenerated
                Pool pool = new Pool(1, Convert.ToDateTime("08:00:00"),
                    Convert.ToDateTime("14:00:00"), 46122, 5, 5, 2.00);
                for (int i = 1; i <= numLanes; i++)
                {
                    pool.addLane(new Lane(i));
                }
                service.addPool(pool);
                service.saveChanges();

                foreach (Pool p in service.getAllPools())
                {
                    Console.WriteLine(" Pool " + p.Id);
                    foreach (Lane l in p.Lanes)
                        Console.WriteLine("   Lane " + l.Number);
                }
                return pool;

            }
            catch (Exception e)
            {
                printError(e);
                return null;
            }

        }
        static void printError(Exception e)
        {
            while (e != null)
            {
                Console.WriteLine("ERROR: " + e.Message);
                e = e.InnerException;
            }
        }

    }
}
