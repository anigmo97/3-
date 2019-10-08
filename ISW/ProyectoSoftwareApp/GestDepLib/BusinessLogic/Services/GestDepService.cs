using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GestDepLib.Persistence;
using GestDepLib.Entities;

namespace GestDepLib.BusinessLogic.Services
{
    public class GestDepService : IGestDepService
    {
        private readonly IDAL dal;
        public GestDepService(IDAL dal)
        {
            this.dal = dal;
        }

        // Método que recupera un curso sabiendo su descripción
        // Ej : findCourseByName("Learning with M. Phelps");
        public Course findCourseByName(string CourseName) {
            IEnumerable<Course> cursos = dal.GetAll<Course>();
            foreach (Course c1 in cursos)
            {
                if (c1.Description == CourseName) { return c1; }
            }
            return null;
        }
        // Método que recupera una piscina tomando su id
        // (el id de piscina no se genera automaticamente
        // Ej: findPoolById(1);
        public Pool findPoolById(int Id) {
            IEnumerable<Pool> pools = dal.GetAll<Pool>();
            foreach (Pool p1 in pools)
            {
                if (p1.Id == Id) { return p1; }
            }
            return null;
        
    }
        // Método que recupera un enrollment dado un usuario
        //findEnrollment("1234567890");
        public Enrollment findEnrollment(string UserId) {
            IEnumerable < Enrollment > enroll = dal.GetAll<Enrollment>();
            foreach (Enrollment e1 in enroll)
            {
                if (e1.User.Id == UserId) { return e1; }
            }
            return null;
        }
        //removeAllData();
        public void removeAllData() {
            dal.Clear<Course>();
            dal.Clear<Monitor>();
            dal.Clear<Person>();
            dal.Clear<User>();
            dal.Clear<Payment>();
            dal.Clear<Enrollment>();
            dal.Clear<Lane>();
            dal.Clear<Pool>();
        }
        public void addCourse(Course c) {
            Pool p = findPoolById(1);
            if (!p.compruebaSolapamientoCurso(c))
            {
                p.añadirHorariosCurso(c);
                dal.Insert(c);
                dal.Commit();
            }
            else throw new ServiceException("Existen horarios solapados");


        }
        //enrollUserToCourse(new DateTime(2017, 08, 16), u, c);
        public void enrollUserToCourse(DateTime fecha, User u, Course c) {
            //Enrollment e = new Enrollment()
            //c.Enrollments.Add()
            Payment p = new Payment(fecha, "descripcion", c.Price);
            dal.Insert(p);
            Enrollment e = new Enrollment(null, fecha, null, p, u, c);
            dal.Insert(e);
            c.Enrollments.Add(e);

        }
        //addFreeSwimPayment(new DateTime(2017, 8, 10, 18, 12, 5));
        public void addFreeSwimPayment(DateTime FechaConHora) {
            Payment p = new Payment(FechaConHora, "Free Swim", 2.0);
            dal.Insert(p);
                }
        public List<Payment> getAllFreeSwimPayments() {
            IEnumerable<Payment> pagos = dal.GetAll<Payment>();

            List<Payment> pagosFree = new List<Payment>();
            
            foreach (Payment p1 in pagos)
            {
                if (p1.Description.Equals("Free Swim")) { pagosFree.Add(p1); }
            }
            return pagosFree;
           
        }
       
        public List<Monitor> compruebaMonitoresLibresParaCurso(Course c)
        {
            List<Monitor> l = new List<Monitor>();
            
                foreach (Monitor m in dal.GetAll<Monitor>())
                {
                if (!c.compruebaSolapamientoHorarioMonitor(m))
                    {

                        l.Add(m);
                        
                    }
                }
            
            return l;
        }
        //addPool(pool);

        public void addPool(Pool pool) { dal.Insert(pool); dal.Commit(); }
        //addMonitor(m)
        public void addMonitor(Monitor m) { dal.Insert(m); }
        //addPayment(e, new DateTime(2017, 8, 16, 12, 30, 0));
        public void addPayment(Enrollment e, DateTime FechaConHora) {
            Payment p = new Payment(FechaConHora, "", e.Course.Price);
            e.Payments.Add(p);
            dal.Insert(p);
            dal.Commit();
        }

        // service.getAllEnrollments()
        public IEnumerable<Enrollment> getAllEnrollments() {
            return dal.GetAll<Enrollment>();

            
        }
        //service.getAllPools()
       public IEnumerable<Pool> getAllPools() { return dal.GetAll<Pool>(); }
        //getFreeLanes(new DateTime(2018, 1, 29, 8, 00, 0), Days.Monday);





                        //****** INACABADO ******/
                        //****** INACABADO ******/
                        //****** INACABADO ******/



        public int getFreeLanes(DateTime FechaConHora, Days dia) {
            int lanesLibres = 6;
            List<int> pos = new List<int>();
            IEnumerable<Course> cursos = dal.GetAll<Course>();
            
            Console.WriteLine("length cursos = " + cursos.Count());
            //List<Course> cursosEseDia = new List<Course>();
            foreach (Course c in cursos)
            {

                Console.WriteLine((DateTime.Compare(c.StartDate, FechaConHora) < 0) &&
                 (DateTime.Compare(FechaConHora, c.FinishDate) < 0) &&
                 (DateTime.Compare(c.StartHour, Convert.ToDateTime(FechaConHora.Hour + ":" + FechaConHora.Minute + ":00")) < 0)
                 && (DateTime.Compare(Convert.ToDateTime(FechaConHora.Hour + ":" + FechaConHora.Minute + ":00"), c.FinishDate) < 0)
                 );
                    if (c.CourseDays == dia)
                { //cursosEseDia.Add(c);
                    if (
                        (DateTime.Compare(c.StartDate, FechaConHora) < 0) &&
                        (DateTime.Compare(FechaConHora, c.FinishDate) < 0) &&
                        (DateTime.Compare(c.StartHour, Convert.ToDateTime(FechaConHora.Hour + ":" + FechaConHora.Minute + ":00")) < 0)
                        && (DateTime.Compare(Convert.ToDateTime(FechaConHora.Hour + ":" + FechaConHora.Minute + ":00"), c.FinishDate) < 0)
                        )
                    {
                        foreach (Lane l in c.Lanes) { pos[l.Number]++; }
                    }
                }

            }
                for (int i = 0; i < pos.Count(); i++)
                {
                    if (pos[i] > 0) { lanesLibres--; }
                }
            

            return lanesLibres;
        }
        public void saveChanges() { dal.Commit(); }

        public List<Course> getCursosActivosYPorEmpezar()
        {
            List<Course> l = new List<Course>();
            foreach(Course c in dal.GetAll<Course>())
            {
                if(c.FinishDate> DateTime.Today)
                {
                    l.Add(c);
                }
            }
            return l;
        }
        public User findUserById(String dni)
        {
           
            foreach(User u in dal.GetAll<User>())
            {
                if (u.Id == dni)
                {
                    return u;
                }
            }
            return null;
        }
        public void addUser(User u)
        {
            dal.Insert(u);
        }

        /* 
         
        public Dictionary

         */


    }
}






    









/*
using System;
using System.Collections.Generic;
using VehicleRental.Domain;
using VehicleRental.Persistence;

namespace VehicleRental.Services
{

    public class VehicleRentalService : IVehicleRentalService
    {
        private readonly IDAL dal;
        public VehicleRentalService(IDAL dal)
        {
            this.dal = dal;
        }

        public void removeAllData()
        {
            dal.Clear<BranchOffice>();
            dal.Clear<Category>();
            dal.Clear<Reservation>();
            dal.Clear<Person>();
            dal.Clear<Customer>();
            dal.Clear<CreditCard>();
            dal.Commit();
        }

        # region Reservation
        public IList<Reservation> findReservationsbyCustomerID(string customerDNI)
        {
            List<Reservation> reservations = new List<Reservation>();
            foreach (Reservation res in dal.GetAll<Reservation>())
            {
                if (res.Customer.Dni.Equals(customerDNI))
                {
                    reservations.Add(res);
                }
            }
            return reservations;
        }

        public void addReservation(Reservation reservation)
        {
            dal.Insert(reservation);
            dal.Commit();
        }
        public void addReservation(Customer customer, BranchOffice pickUpOffice, DateTime pickupDate,
            BranchOffice returnOffice, DateTime returnDate, Category cat, IEnumerable<Person> drivers)
        {
            Reservation res = new Reservation(customer, pickUpOffice, pickupDate, returnOffice, returnDate, cat, drivers);
            //Adding reservation to DB
            addReservation(res);
        }
        #endregion

        #region Customer
        public IList<Customer> findAllCustomers()
        {
            return new List<Customer>(dal.GetAll<Customer>());
        }

        public Customer findCustomerByDni(string dni)
        {
            return dal.GetById<Customer>(dni);
        }

        public Customer migratePersonToCustomer(Person person, DateTime registrationDate, CreditCard cc)
        {

            Customer customer = new Customer(person.Dni, person.Name, person.Address, person.City, person.PostalCode,
                person.DateDriverLicense, registrationDate, cc);
            foreach (Reservation reservation in person.Reservations)
                customer.Reservations.Add(reservation);
            dal.Delete(person);
            dal.Insert(customer);
            dal.Commit();
            return customer;
        }
        #endregion

        #region Person
        public IList<Person> findAllPersons()
        {
            return new List<Person>(dal.GetAll<Person>());
        }

        public Person findPersonByDni(string dni)
        {
            return dal.GetById<Person>(dni);
        }

        public void addPerson(Person person)
        {
            if (dal.GetById<Person>(person.Dni) == null)
            {
                dal.Insert<Person>(person);
                dal.Commit();
            }
            else throw new ServiceException("Person already exists.");
        }
        #endregion

        #region BranchOffice
        public IList<BranchOffice> findAllBranchOffices()
        {
            return new List<BranchOffice>(dal.GetAll<BranchOffice>());
        }

        public void addBranchOffice(BranchOffice br)
        {
            dal.Insert<BranchOffice>(br);
            dal.Commit();
        }
        #endregion

        #region Category
        public IList<Category> findAllCategories()
        {
            return new List<Category>(dal.GetAll<Category>());
        }

        public void addCategory(Category cat)
        {
            dal.Insert<Category>(cat);
            dal.Commit();
        }
        #endregion

        #region CreditCard
        public CreditCard findCreditCardByNumber(string number)
        {
            return dal.GetById<CreditCard>(number);
        }
        #endregion
    }
}*/
