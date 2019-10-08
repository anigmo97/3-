using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
//using GestDep.Domain;
using System.Data.Entity;
using GestDepLib.Entities;

namespace GestDepLib.Persistence
{
    public class GestDepDbContext : DbContext
    {


        public GestDepDbContext() : base("Name=GestDepDbConnection") //this is the connection string name
        {
            /*
            See DbContext.Configuration documentation
            */
            Configuration.ProxyCreationEnabled = true;
            Configuration.LazyLoadingEnabled = true;
        }

        static GestDepDbContext()
        {
            //Database.SetInitializer<VehicleRentalDbContext>(new CreateDatabaseIfNotExists<VehicleRentalDbContext>());
            Database.SetInitializer<GestDepDbContext>(new DropCreateDatabaseIfModelChanges<GestDepDbContext>());
            //Database.SetInitializer<VehicleRentalDbContext>(new DropCreateDatabaseAlways<VehicleRentalDbContext>());
            //Database.SetInitializer<VehicleRentalDbContext>(new VehicleRentalDbInitializer());
            //Database.SetInitializer(new NullDatabaseInitializer<VehicleRentalDbContext>());
        }

        public IDbSet<Course> Courses { get; set; }
        public IDbSet<Enrollment> Enrollments { get; set; }
        public IDbSet<Lane> Lanes { get; set; }
        public IDbSet<Monitor> Monitors { get; set; }
        public IDbSet<Payment> Payments { get; set; }
        public IDbSet<Person> Persons { get; set; }
        public IDbSet<Pool> Pools { get; set; }
        public IDbSet<User> Users { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            // Primary keys with non conventional name
            /*
            modelBuilder.Entity<Person>().HasKey(p => p.Dni);
            modelBuilder.Entity<Customer>().HasKey(c => c.Dni);
            modelBuilder.Entity<CreditCard>().HasKey(c => c.Digits);
            */
            // Classes with more than one relationship
            /*
            modelBuilder.Entity<Reservation>().HasRequired(r => r.PickUpOffice).WithMany(o => o.PickUpReservations).WillCascadeOnDelete(false);
            modelBuilder.Entity<Reservation>().HasRequired(r => r.ReturnOffice).WithMany(o => o.ReturnReservations).WillCascadeOnDelete(false);
            */
        }

    }

}

