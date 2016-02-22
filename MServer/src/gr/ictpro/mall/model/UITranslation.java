package gr.ictpro.mall.model;

public class UITranslation implements java.io.Serializable {

    /**
     * 
     */
    private static final long serialVersionUID = -3715859089671812756L;

    private String originalText;
    private String translatedText;
    
    public UITranslation(String originalText, String translatedText) {
	super();
	this.originalText = originalText;
	this.translatedText = translatedText;
    }
    public String getOriginalText() {
        return originalText;
    }
    public void setOriginalText(String originalText) {
        this.originalText = originalText;
    }
    public String getTranslatedText() {
        return translatedText;
    }
    public void setTranslatedText(String translatedText) {
        this.translatedText = translatedText;
    }
    
    
}
