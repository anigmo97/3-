using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GestDepLib.Entities
{
    public partial class TablaOcupacion
    {
        
        public ArrayList tabla
        {
            get;
            set;
        }
        public int PoolId
        {
            get;
            set;
        }
        public DateTime OpeningHour
        {
            get;
            set;
        }
        public DateTime ClosingHour
        {
            get;
            set;
        }
        public int num_turnos
        {
            get;
            set;
        }
    }
}
