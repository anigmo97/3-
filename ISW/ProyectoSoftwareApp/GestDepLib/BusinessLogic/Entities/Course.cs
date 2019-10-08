using GestDepLib.BusinessLogic.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GestDepLib.Entities
{
    public partial class Course
    {
        public Course() {
            // this.CourseDays
            this.Lanes = new List<Lane>();
            this.Enrollments = new List<Enrollment>();

        }
        public Course(Boolean Cancelled,Days courseDays,string Description, 
            TimeSpan Duration, DateTime FinishDate,
            int MaximumEnrollments,int MinimumEnrollments,double Price,
            DateTime StartDate, DateTime StartHour
            )
        {
            this.Cancelled =Cancelled;
            this.CourseDays = courseDays;
            this.Description =Description;
            this.Duration =Duration;
            this.FinishDate =FinishDate;
            this.MaximunEnrollments =MaximumEnrollments;
            this.MinimunEnrollments =MinimumEnrollments;
            this.Price =Price;
            this.StartDate =StartDate;
            this.StartHour =StartHour;
            this.Lanes = new List<Lane>();
            this.Enrollments = new List<Enrollment>();
        }
        /* Constructor sobrecargado con el mismo orden que Program.cs*/
         public Course(String Description, DateTime StartDate, DateTime FinishDate, 
             DateTime StartHour, TimeSpan Duration, Days courseDays, 
             int MinimumEnrollments, int MaximumEnrollments, bool Cancelled, double Price)
        {
            this.Cancelled = Cancelled;
            this.CourseDays = courseDays;
            this.Description = Description;
            this.Duration = Duration;
            this.FinishDate = FinishDate;
            this.MaximunEnrollments = MaximumEnrollments;
            this.MinimunEnrollments = MinimumEnrollments;
            this.Price = Price;
            this.StartDate = StartDate;
            this.StartHour = StartHour;
            this.Lanes = new List<Lane>();
            this.Enrollments = new List<Enrollment>();

            //añadido
            
        }

        // Método para añadir una lane más al atributo Lanes de Course
        public void addLane(Lane l) { Lanes.Add(l); }
        // Método para fijar un Monitor al Curso
        public void setMonitor(Monitor m) {
            if (!this.compruebaSolapamientoHorarioMonitor(m) )
            {
                if (Monitor != null)
                {
                    Monitor.Courses.Remove(this);
                }
                Monitor = m;
                m.Courses.Add(this);
            } else throw new ServiceException("El monitor está asignado a otro curso en este horario o ya hay monitor asignado"); 
        }
        // Método para encontrar un enrollment a un Course mediante 
        // el id del usuario
        public Enrollment findEnrollment(string UserId) {
            for (int i = 0; i < Enrollments.Count(); i++) {
                if (Enrollments.ElementAt(i).User.Id == UserId) {
                    return Enrollments.ElementAt(i); }
            }
            return null;
        }
        public List<DateTime> getDias()
        {
            List<DateTime> l = new List<DateTime>();
            DateTime dia = StartHour;
            
            
           
            //Console.WriteLine(dia.ToString());
            while (dia <= FinishDate)
            {
                
                switch (dia.DayOfWeek)
                {
                    case DayOfWeek.Monday:
                        if((CourseDays & Days.Monday) == Days.Monday){l.Add(dia);}
                        break;
                    case DayOfWeek.Tuesday:
                        if ((CourseDays & Days.Tuesday) == Days.Tuesday) { l.Add(dia); }
                        break;
                    case DayOfWeek.Wednesday:
                        if ((CourseDays & Days.Wednesday) == Days.Wednesday) { l.Add(dia); }
                        break;
                    case DayOfWeek.Thursday:
                        if ((CourseDays & Days.Thursday) == Days.Thursday) { l.Add(dia); }
                        break;
                    case DayOfWeek.Friday:
                        if ((CourseDays & Days.Friday) == Days.Friday) { l.Add(dia); }
                        break;
                    case DayOfWeek.Saturday:
                        if ((CourseDays & Days.Saturday) == Days.Saturday) { l.Add(dia); }
                        break;
                    case DayOfWeek.Sunday:
                        if ((CourseDays & Days.Sunday) == Days.Sunday) { l.Add(dia); }
                        break;
                    default:
                        break;
                }
                dia = dia.AddDays(1.0);//aumentamos un dia
            }
            
            
            
                return l;

            
        }
        public double calculaPrecio(User u)
        {
            return this.Price ;
        }


        public Dictionary<Lane,int> getLanesDictionary() {
            Dictionary<Lane, int> d = new Dictionary<Lane, int>();
            foreach (Lane lane in this.Lanes) // por cada lane de la piscina
            {
                d.Add(lane, 1);
            }
                return d;
        }

        public bool compruebaSolapamientoFecha(DateTime fechaConHora)
        {
           
            foreach(DateTime d in getDias())
            {
                if (d.Equals(fechaConHora)) { return true; }
            }
            if (this.getDias().Contains(fechaConHora)) { return true; }
            else {
                return false;
            }
        }

        public bool compruebaSolapamientoHorarioMonitor(Monitor m)
        {
            List<DateTime> l = m.getHorariosOcupado();
            foreach (DateTime d in l) {
                if (compruebaSolapamientoFecha(d)) { return true; }
            } 
            return false; 
        }
    }
}
