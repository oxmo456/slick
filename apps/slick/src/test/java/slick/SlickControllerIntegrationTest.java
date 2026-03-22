package slick;

import static org.junit.jupiter.api.Assertions.assertEquals;

import com.microsoft.playwright.APIRequest;
import com.microsoft.playwright.APIRequestContext;
import com.microsoft.playwright.APIResponse;
import com.microsoft.playwright.Playwright;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.platform.runner.JUnitPlatform;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;

@RunWith(JUnitPlatform.class)
@SpringBootTest(
    classes = Application.class,
    webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class SlickControllerIntegrationTest {

  @LocalServerPort private int port;

  private Playwright playwright;
  private APIRequestContext request;

  @BeforeEach
  void setUp() {
    playwright = Playwright.create();
    request =
        playwright
            .request()
            .newContext(new APIRequest.NewContextOptions().setBaseURL("http://localhost:" + port));
  }

  @AfterEach
  void tearDown() {
    request.dispose();
    playwright.close();
  }

  @Test
  void indexReturnsGreeting() {
    APIResponse response = request.get("/");
    assertEquals(200, response.status());
    assertEquals("Greetings from Slick!", response.text());
  }
}
