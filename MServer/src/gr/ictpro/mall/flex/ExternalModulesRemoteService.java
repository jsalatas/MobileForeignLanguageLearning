package gr.ictpro.mall.flex;


import java.util.List;

import javax.annotation.Resource;

public class ExternalModulesRemoteService {
    @Resource
    private List<String> externalModules;

    public List<String> getExternalModules() {
	return externalModules;
    }

}
