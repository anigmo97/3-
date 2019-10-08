using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GestDepLib.Entities
{
    public partial class User : Person
    {
        protected User() : base() {  }
        public User(DateTime BirthDay,Boolean Retired, string Address, string IBAN, 
            string Id, string Nombre, int ZipCode)
            : base(Address, IBAN,Id, Nombre, ZipCode)
        {
           
            this.BirthDate = BirthDay;
            this.Retired = Retired;

        }
        /* Constructor sobrecargado con el mismo orden que Program.cs*/
        public User(string Id, string Nombre, string Address, 
            int ZipCode, string IBAN, DateTime BirthDate, bool Retired)
            : base(Address, IBAN,Id, Nombre, ZipCode)
        {

            this.BirthDate = BirthDate;
            this.Retired = Retired;

        }
        public User introduceDatosUsuarioPorTeclado()
        {
            Console.WriteLine("escriba el nombre de usuario");
            Console.ReadLine();
            return null;
        }


    }
}
