package gr.ictpro.mall.client.utils.date
{
	public class DateUtils
	{
		public static function compareNoTime(date1:Date, date2:Date):int
		{
 			if(date1.fullYear < date2.fullYear) {
				return -1;
			} else if(date1.fullYear > date2.fullYear) {
				return 1;
			} else {
				if(date1.month < date2.month) {
					return -1;
				} else if(date1.month > date2.month) {
					return 1;
				} else {
					if(date1.date < date2.date) {
						return -1;
					} else if(date1.date > date2.date) {
						return 1;
					}
				}
			}
			return 0;
		}
	}
}