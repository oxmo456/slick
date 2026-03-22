package slick;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class K8sContext {

  @Value("${app.pod.name}")
  private String podName;

  @Value("${app.pod.uid}")
  private String podUid;

  public String getPodName() {
    return podName;
  }

  public String getPodUid() {
    return podUid;
  }
}
