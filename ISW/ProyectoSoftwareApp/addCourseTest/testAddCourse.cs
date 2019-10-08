using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GestDepLib.Persistence;
using GestDepLib.BusinessLogic;
using GestDepLib.Entities;
using GestDepLib.BusinessLogic.Services;

namespace addCourseTest
{
    class testAddCourse
    {
        static void Main(string[] args)
        {

            try
            {
                IGestDepService service =
                    new GestDepService(new EntityFrameworkDAL(new GestDepDbContext()));

                new testAddCourse(service);
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
        testAddCourse(IGestDepService service)
        {
            this.service = service;
            service.removeAllData();
            Console.WriteLine("Ejecutando test sobre la semana 20/11/2017 -- 25-11-2017...");
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();
            Pool p = creaPiscina(3);
            Course c = new Course("curso1", new DateTime(2017, 11, 20),
                    new DateTime(2017, 11, 26), new DateTime(2017, 11, 20, 9, 30, 0),
                    new TimeSpan(0, 45, 0),
                    Days.Monday | Days.Wednesday | Days.Friday,
                    6, 20, false, 100);
            c.addLane(p.findLane(1));
            c.addLane(p.findLane(2));
            // curso en los mismos días en las mismas horas en las mismas líneas
            // SOLAPAN
            Course c2 = new Course("curso2", new DateTime(2017, 11, 20),
                    new DateTime(2017, 11, 26), new DateTime(2017, 11, 20, 9, 30, 0),
                    new TimeSpan(0, 45, 0),
                    Days.Monday | Days.Wednesday | Days.Friday,
                    6, 20, false, 100);
            c2.addLane(p.findLane(1));
            c2.addLane(p.findLane(2));
            // curso en distintos dias a la misma hora mismas líneas
            //NO SOLAPAN
            Course c3 = new Course("curso3", new DateTime(2017, 11, 20),
                    new DateTime(2017, 11, 26), new DateTime(2017, 11, 20, 9, 30, 0),
                    new TimeSpan(0, 45, 0),
                    Days.Tuesday|Days.Thursday|Days.Saturday,
                    6, 20, false, 100);
            c3.addLane(p.findLane(1));
            c3.addLane(p.findLane(2));
            // curso mismos días mismas horas distintas líneas
            // No solapan
            Course c4 = new Course("curso4", new DateTime(2017, 11, 20),
                    new DateTime(2017, 11, 26), new DateTime(2017, 11, 20, 9, 30, 0),
                    new TimeSpan(0, 45, 0),
                    Days.Monday | Days.Wednesday | Days.Friday,
                    6, 20, false, 100);
            c4.addLane(p.findLane(3));
            //curso distinto día distinta hora
            // no solapan
            Course c5 = new Course("curso5", new DateTime(2017, 11, 20),
                    new DateTime(2017, 11, 26), new DateTime(2017, 11, 20, 11, 00, 0),
                    new TimeSpan(0, 45, 0),
                    Days.Monday | Days.Wednesday | Days.Friday,
                    6, 20, false, 100);
            c5.addLane(p.findLane(2));
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();
            muestraEstadoPiscinaYSolapamiento(p,c,c2,c3,c4,c5);
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();
            Console.WriteLine("DEBE AÑADIRSE y los lunes miercoles y viernes solo habrá una lane libre a las 9:30");
            añadeCursoAPiscina(c, p);
            Console.WriteLine(p.dibujaOcupacionSemana(new DateTime(2017, 11, 20)));
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();
            Console.WriteLine("NO DEBE AÑADIRSE ");
            añadeCursoAPiscina(c2, p);
            Console.WriteLine(p.dibujaOcupacionSemana(new DateTime(2017, 11, 20)));
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();
            Console.WriteLine("DEBE AÑADIRSE y a las 9:30 solo quedará una lane cada día");
            añadeCursoAPiscina(c3, p);
            Console.WriteLine(p.dibujaOcupacionSemana(new DateTime(2017, 11, 20)));
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();
            Console.WriteLine("DEBE AÑADIRSE y los lunes miercoles y viernes no quedarán lanes libres");
            añadeCursoAPiscina(c4, p);
            Console.WriteLine(p.dibujaOcupacionSemana(new DateTime(2017, 11, 20)));
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();
            Console.WriteLine("DEBE AÑADIRSE y los lunes miercoles y viernes habra 2 lanes libres a las 11:00");
            añadeCursoAPiscina(c5, p);
            Console.WriteLine(p.dibujaOcupacionSemana(new DateTime(2017, 11, 20)));
            Console.WriteLine("Press any key to continue...\n\n");
            Console.ReadKey();
            //if (!haySolapamiento)
            //{
            //    Console.WriteLine("Añadiendo curso...");
            //    añadeCursoAPiscina(c, service.findPoolById(1));
            //}
            //else { Console.WriteLine("No se añadió porque se solapaban"); }
            //Console.WriteLine("Press any key to continue...\n\n");
            //Console.ReadKey();
            //muestraEntradas();
            //Console.WriteLine("Press any key to continue...\n\n");
            //Console.ReadKey();
            //muestraOcupacion();
            //Console.WriteLine("Press any key to continue...\n\n");
            //Console.ReadKey();
            //pruebaAñadirEntrada(new DateTime(2017, 11, 20, 9, 30, 0), c.getLanesDictionary());
            //Console.WriteLine("Press any key to continue...\n\n");
            //Console.ReadKey();
            //muestraEntradas();
            //Console.WriteLine("Press any key to continue...\n\n");
            //Console.ReadKey();
            //muestraOcupacion();
            //Console.WriteLine("Press any key to continue...\n\n");
            //Console.ReadKey();
            //if (!haySolapamiento)
            //{
            //    Console.WriteLine("Añadiendo curso...");
            //    añadeCursoAPiscina(c, service.findPoolById(1));
            //}
            //else { Console.WriteLine("No se añadió porque se solapaban"); }
            //Console.WriteLine("Press any key to continue...\n\n");
            //Console.ReadKey();
            //creaCurso2yAñadelo();

            //-------------------------------------------------------
            //Console.WriteLine("Press any key to continue...");
            //Console.ReadKey();
            //Course c1 = creaCurso("curso2");
            //Console.WriteLine("Press any key to continue...");
            //Console.ReadKey();
            //añadeLanesACurso(c1);
            //Console.WriteLine("Press any key to continue...");
            //Console.ReadKey();
            //añadeCursoAPiscina(c1, service.findPoolById(1));
            //Console.WriteLine("Press any key to continue...");
            //Console.ReadKey();


        }
        public Pool creaPiscina(int numLanes)
        {
            Console.WriteLine();
            Console.WriteLine("Creando piscina con "+numLanes+" lanes...");

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
        void muestraEstadoPiscinaYSolapamiento(Pool p,Course c1, Course c2, Course c3, Course c4, Course c5)
        {
            Console.WriteLine("Lineas libres piscina:");
            Console.WriteLine(p.dibujaOcupacionSemana(new DateTime(2017, 11, 20)));
            Console.WriteLine("SOLUCIÓN = Solapamiento c = " + p.compruebaSolapamientoCurso(c1));
            Console.WriteLine("TEST =Solapamiento c = " + p.compruebaSolapamientoCurso(c1)+"\n");
            Console.WriteLine("SOLUCIÓN = Solapamiento c2 = " + p.compruebaSolapamientoCurso(c2));
            Console.WriteLine("TEST =Solapamiento c2 = " + p.compruebaSolapamientoCurso(c2) + "\n");
            Console.WriteLine("SOLUCIÓN = Solapamiento c3 = " + p.compruebaSolapamientoCurso(c3));
            Console.WriteLine("TEST =Solapamiento c3 = " + p.compruebaSolapamientoCurso(c3) + "\n");
            Console.WriteLine("SOLUCIÓN = Solapamiento c4 = " + p.compruebaSolapamientoCurso(c4));
            Console.WriteLine("TEST =Solapamiento c4 = " + p.compruebaSolapamientoCurso(c4) + "\n");
            Console.WriteLine("SOLUCIÓN = Solapamiento c5 = " + p.compruebaSolapamientoCurso(c5));
            Console.WriteLine("TEST =Solapamiento c5 = " + p.compruebaSolapamientoCurso(c5) + "\n");
           


        }
        Course creaCurso(string nom)
        {
            Console.WriteLine();
            Console.WriteLine("Creando Curso...");



            try
            {
                // Course(String description, DateTime startDate, DateTime finishDate, DateTime startHour, TimeSpan duration, Days courseDays, int minimunEnrollments, int maximunEnrollments, bool cancelled, double price)
                Course c = new Course(nom, new DateTime(2017, 11, 20),
                    new DateTime(2017, 11, 26), new DateTime (2017,11,20,9,30,0),
                    new TimeSpan(0, 45, 0),
                                  Days.Monday | Days.Wednesday | Days.Friday,
                                  6, 20, false, 100);
                Console.WriteLine("Curso creado\n Fecha Inicio: " + c.StartDate + "\nFecha Fin: " + c.FinishDate);
                Console.WriteLine("Hora Inicio: " + c.StartHour + "\nDuracion: " + c.Duration);
                Console.WriteLine("Dias que se imparte:" + c.CourseDays);
                Console.WriteLine("StartHour + duration (Fisnish Hour) = " + c.StartHour.Add(c.Duration));
                Console.WriteLine("numero de calles asignadas " + c.Lanes.Count());
                Console.WriteLine("Descripcion/nombre Curso =" + c.Description);
                string st = "Lanes = [";
                foreach (Lane l in c.Lanes) { st += +l.Number; }
                st += "]";
                Console.WriteLine("calles asignadas " + st);
                return c;
            }
            catch (Exception e)
            {

                printError(e);
                return null;
            }

        }

        void añadeLanesACurso(Course c)
        {
            Console.WriteLine();
            Console.WriteLine("Añadiendo Lanes ...");



            try
            {
                Pool pool = service.findPoolById(1);

                c.addLane(pool.findLane(1));
                c.addLane(pool.findLane(2));
                string st = "= [";
                foreach (Lane l in c.Lanes) { st += +l.Number + ","; }
                st = st.Substring(0, st.Length - 1);
                st += "]";
                Console.WriteLine("calles asignadas " + st);

            }
            catch (Exception e)
            {
                printError(e);
            }

        }
        List<DateTime> calculaFechasCurso(Course c)
        {
            try
            {
                Console.WriteLine("Calculando Fechas del curso " + c.Description + "...");
                List<DateTime> listaFechas = c.getDias();
                return listaFechas;
            }
            catch (Exception e)
            {
                printError(e);
                return null;
            }
        }
        void muestraTurnosPiscina()
        {
            try
            {
                Pool p = service.findPoolById(1);
                int cont = 1;
                foreach (DateTime d in p.getListaTurnos())
                {
                    Console.WriteLine("Turno "+cont+ ": "+d.ToString());
                    cont++;
                }
                
            }
            catch (Exception e)
            {
                printError(e);
              
            }
        }
        void creaCurso2yAñadelo()
        {
            Course c2 = new Course("curso2", new DateTime(2017, 11, 20),
                                new DateTime(2017, 11, 26), new DateTime(2017, 11, 20, 9, 30, 0),
                                new TimeSpan(0, 45, 0),
                                              Days.Monday | Days.Wednesday | Days.Friday,
                                              6, 20, false, 100);
            Pool pool = service.findPoolById(1);

            c2.addLane(pool.findLane(3));
            
                service.addCourse(c2);
            
            muestraOcupacion();


        }
        public void añadeCursoAPiscina(Course c, Pool p)
        {
            try
            {
                service.saveChanges();
                Console.WriteLine("Añadiendo curso " + c.Description + " a piscina " + p.Id + "...");
                service.addCourse(c);
                service.saveChanges();


            }
            catch (Exception e)
            {
                printError(e);
            }
        }

        bool calculaSolapamiento(Course c, Pool p)
        {
            try
            {
                return p.compruebaSolapamientoCurso(c);
            }
            catch (Exception e)
            {
                printError(e);
                return true;
            }
        }
        void muestraEntradas()
        {
            try
            {
                Pool p = service.findPoolById(1);
                foreach(DateTime d in p.tabla.Keys)
                {
                    string st = "";
                    foreach(Lane l in p.tabla[d].Keys)
                    {
                        st += "Lane" + l.Number + "--> " + p.tabla[d][l]+"  ";
                    }
                    Console.WriteLine(d.ToString()+" "+st +"getFreeLanes() = "+p.getFreeLanes(d));
                }
            }
            catch (Exception e)
            {
                printError(e);
                
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
        void muestraOcupacion()
        {
          



            try
            {
                Console.WriteLine("Mostrando tabla para la semana del lunes 20/11/2017");
                Pool pool = service.findPoolById(1);
                Console.WriteLine(pool.dibujaOcupacionSemana(new DateTime(2017,11,20)));

            }
            catch (Exception e)
            {
                printError(e);
            }

        }
        public void pruebaAñadirEntrada(DateTime d ,Dictionary<Lane,int> d2)
        {
            try
            {
                Console.WriteLine("añadiendo entrada en " + d.ToString());
                Pool p = service.findPoolById(1);
                if (!p.compruebaSolapamientoEntrada(d, d2))
                {
                    p.insertarEntrada(d, d2);
                }else { Console.WriteLine("No se inserto porque se solapa"); }
               
            }
            catch (Exception e)
            {
                printError(e);
                
            }
        }
    }
}

