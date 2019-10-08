using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GestDepLib.Entities
{
    public partial class Enrollment
    {
        public Enrollment()
        {
            this.User = null;
            this.Course = null;
            this.Payments = new List<Payment>();

        }
        public Enrollment(DateTime? CancellationDate, DateTime EnrollmentDate,
            DateTime? ReturnedFirstCuotaIfCancelledCourse,
            Payment p,User u,Course c)
        {
            this.CancellationDate = CancellationDate;
            this.EnrollmentDate = EnrollmentDate;
            this.ReturnedFirstCuotaIfCancelledCourse = ReturnedFirstCuotaIfCancelledCourse;
            this.Payments = new List<Payment>();
            this.Payments.Add(p);
            this.User = u;
            this.Course = Course;

        }
    }
}
