package gr.ictpro.mall.client.model
{
	import gr.ictpro.mall.client.model.vo.Course;
	import gr.ictpro.mall.client.model.vo.Project;
	import gr.ictpro.mall.client.model.vo.User;
	import gr.ictpro.mall.client.model.vomapper.DetailMapper;
	import gr.ictpro.mall.client.runtime.Device;
	import gr.ictpro.mall.client.view.ProjectView;
	import gr.ictpro.mall.client.view.components.ProjectComponent;

	public class ProjectModel extends AbstractModel implements IServerPersistent
	{
		public function ProjectModel()
		{
			super(Project, ProjectView, ProjectComponent);
			addDetail(new DetailMapper("Courses", "courses", Course, null, null, null, answerTrue, null, null, null));
			addDetail(new DetailMapper("Users", "users", User, null, null, addFilter, answerFalse, null, null, null));
		}
		
		
		public function addFilter(user:User):Boolean {
			return UserModel.isStudent(user) ||UserModel.isTeacher(user); 
		}
		
		public function answerTrue(o:Object):Boolean
		{
			return true;
		}

		public function answerFalse(o:Object):Boolean
		{
			return false;
		}

		public function get destination():String
		{
			return "projectRemoteService";
		}
		
		public function get saveMethod():String
		{
			return "updateProject";
		}
		
		public function get deleteMethod():String
		{
			return "deleteProject";
		}
		
		public function get listMethod():String
		{
			return "getProjects";
		}
		
		public function get saveErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Save Project.");
		}
		
		public function get deleteErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Delete Project.");
		}
		
		public function get listErrorMessage():String
		{
			return Device.translations.getTranslation("Cannot Get Projects.");
		}
		
		public function get idField():String
		{
			return "id";
		}
		
		public function idIsNull(vo:Object):Boolean
		{
			return isNaN(vo[idField]);
		}
	}
}