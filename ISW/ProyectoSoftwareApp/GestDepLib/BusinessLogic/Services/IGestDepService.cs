using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GestDepLib.Persistence;
using GestDepLib.Entities;

namespace GestDepLib.BusinessLogic.Services
{
    public interface IGestDepService
    {
        void addUser(User u);
        User findUserById(string dni);
        void addCourse(Course c);
        Course findCourseByName(string CourseName);
        Pool findPoolById(int Id);
        Enrollment findEnrollment(string UserId);
        void removeAllData();
       void enrollUserToCourse(DateTime fecha, User u, Course c);
        //addFreeSwimPayment(new DateTime(2017, 8, 10, 18, 12, 5));
        void addFreeSwimPayment(DateTime FechaConHora);
        void addPool(Pool pool);
        void addMonitor(Monitor m);
        void addPayment(Enrollment e, DateTime FechaConHora);
        IEnumerable<Enrollment> getAllEnrollments();
        //List<Pool> getAllPools();
        IEnumerable<Pool> getAllPools();
        int getFreeLanes(DateTime FechaConHora, Days dia);
        void saveChanges();
        List<Monitor> compruebaMonitoresLibresParaCurso(Course c);
        List<Payment> getAllFreeSwimPayments();
        List<Course> getCursosActivosYPorEmpezar();
    }
}

/*
using System;
using System.Collections.Generic;
using VehicleRental.Domain;

namespace VehicleRental.Services
{
    public interface IVehicleRentalService
    {
        void addBranchOffice(BranchOffice br);
        void addCategory(Category cat);
        void addPerson(Person person);
        void addReservation(Reservation reservation);
        void addReservation(Customer customer, BranchOffice pickUpOffice, DateTime pickupDate, BranchOffice returnOffice, DateTime returnDate, Category cat, IEnumerable<Person> drivers);
        IList<BranchOffice> findAllBranchOffices();
        IList<Category> findAllCategories();
        IList<Customer> findAllCustomers();
        IList<Person> findAllPersons();
        CreditCard findCreditCardByNumber(string number);
        Customer findCustomerByDni(string dni);
        Person findPersonByDni(string dni);
        IList<Reservation> findReservationsbyCustomerID(string customerDNI);
        Customer migratePersonToCustomer(Person person, DateTime registrationDate, CreditCard cc);
        void removeAllData();
    }
}*/
