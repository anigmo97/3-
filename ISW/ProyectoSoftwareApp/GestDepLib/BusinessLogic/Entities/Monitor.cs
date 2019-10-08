using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GestDepLib.Entities
{
    public partial class Monitor : Person
    {
        protected Monitor() : base() { this.Courses = new List<Course>(); }
        public Monitor(string Ssn,string Address, string IBAN,
            string Id, string Nombre, int ZipCode)
            : base(Address, IBAN,Id, Nombre, ZipCode)
        {
            this.Courses = new List<Course>();
            this.Ssn = Ssn;

        }
        /* Constructor sobrecargado con el mismo orden que Program.cs*/
        public Monitor(string Id, string Nombre, string Address, int ZipCode, string IBAN, string Ssn)
        : base(Address, IBAN,Id, Nombre, ZipCode)
        {
            this.Courses = new List<Course>();
            this.Ssn = Ssn;

        }
        public List<DateTime> getHorariosOcupado()
        {
            List<DateTime> l = new List<DateTime>();
            foreach(Course c in this.Courses)
            {
                foreach(DateTime d in c.getDias())
                {
                    l.Add(d);
                }
            }
            return l;
        }
    }
}
