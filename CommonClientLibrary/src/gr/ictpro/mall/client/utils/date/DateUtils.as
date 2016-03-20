package gr.ictpro.mall.client.utils.date
{
	import flash.globalization.DateTimeStyle;
	
	import mx.collections.ArrayCollection;
	import mx.core.mx_internal;
	
	import spark.formatters.DateTimeFormatter;
	
	import gr.ictpro.mall.client.runtime.Device;
	
	use namespace mx_internal;

	public class DateUtils
	{
		[Bindable]
		public static var dayNames:ArrayCollection = getDayNames(); 
			
			
		private static function getDayNames():ArrayCollection
		{
			var res:ArrayCollection = new ArrayCollection([Device.translations.getTranslation('Sunday'), 
			Device.translations.getTranslation('Monday'), 
			Device.translations.getTranslation('Tuesday'), 
			Device.translations.getTranslation('Wednesday'), 
			Device.translations.getTranslation('Thusrday'), 
			Device.translations.getTranslation('Friday'), 
			Device.translations.getTranslation('Saturday')]);
			
			return res;
		}

		[Bindable]
		public static var shortDayNames:ArrayCollection = getShortDayNames(); 
			
			
		private static function getShortDayNames():ArrayCollection
		{
			var res:ArrayCollection = new ArrayCollection([Device.translations.getTranslation('Sun'), 
			Device.translations.getTranslation('Mon'), 
			Device.translations.getTranslation('Tue'), 
			Device.translations.getTranslation('Wed'), 
			Device.translations.getTranslation('Thu'), 
			Device.translations.getTranslation('Fri'), 
			Device.translations.getTranslation('Sat')]);
			
			return res;
		}

		[Bindable]
		public static var monthNames:ArrayCollection = getMonthNames(); 
			
		private static function getMonthNames():ArrayCollection
		{
			var res:ArrayCollection = new ArrayCollection([
			Device.translations.getTranslation('January'), 
			Device.translations.getTranslation('February'), 
			Device.translations.getTranslation('March'), 
			Device.translations.getTranslation('April'), 
			Device.translations.getTranslation('May'), 
			Device.translations.getTranslation('June'), 
			Device.translations.getTranslation('July'), 
			Device.translations.getTranslation('August'), 
			Device.translations.getTranslation('September'), 
			Device.translations.getTranslation('October'), 
			Device.translations.getTranslation('November'), 
			Device.translations.getTranslation('December')]);
			return res;
		}

		public static function reload():void
		{
			dayNames= getDayNames();
			shortDayNames = getShortDayNames();
			monthNames = getMonthNames();
		}
		
		private static var times:ArrayCollection = null;
		
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
		
//		public function toLocalTime(date:Date):Date
//		{
//			
//		}
	
		public static function toShortDate(date:Date):String
		{
			var dtf:DateTimeFormatter = new DateTimeFormatter();
			dtf.setStyle("locale", Device.locale);
			dtf.dateStyle = DateTimeStyle.SHORT;
			dtf.timeStyle = DateTimeStyle.NONE;
			
			return dtf.format(date);
		}

		public static function toShortDateTime(date:Date):String
		{
			var dtf:DateTimeFormatter = new DateTimeFormatter();
			dtf.setStyle("locale", Device.locale);
			dtf.dateStyle = DateTimeStyle.SHORT;
			dtf.timeStyle = DateTimeStyle.SHORT;
			
			return dtf.format(date);
		}

		public static function toShortTime(date:Date):String
		{
			var dtf:DateTimeFormatter = new DateTimeFormatter();
			dtf.setStyle("locale", Device.locale);
			dtf.dateStyle = DateTimeStyle.NONE;
			dtf.timeStyle = DateTimeStyle.SHORT;
			
			return dtf.format(date);
		}

		public static function getTimesList():ArrayCollection
		{
			if(times == null) {
				times = new ArrayCollection();
				var date:Date = new Date();
				date.setHours(0, 0, 0, 0);
				times.addItem(date);
				for(var i:int=1;i<96; i++) {
					date = new Date(date);
					date.minutes += 15;
					times.addItem(date);
				}
			}
			
			return times;
		}
	}
}