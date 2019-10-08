namespace GestDepLib.Entities
{
    public partial class Person
    {
        public Person()
        {


        }
        public Person(string Address, string IBAN,string Id, string Nombre, int ZipCode)
        {
            this.Address = Address;
            this.IBAN = IBAN;
            this.Id = Id;
            this.Name = Nombre;
            this.ZipCode = ZipCode;

        }
    }
}
