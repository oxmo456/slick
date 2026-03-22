package slick;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertNotNull;

import com.microsoft.playwright.Browser;
import com.microsoft.playwright.JSHandle;
import com.microsoft.playwright.Page;
import com.microsoft.playwright.Playwright;
import org.junit.jupiter.api.Test;
import org.junit.platform.runner.JUnitPlatform;
import org.junit.runner.RunWith;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.web.server.LocalServerPort;

@RunWith(JUnitPlatform.class)
@SpringBootTest(
    classes = Application.class,
    webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class SlickWebSocketIntegrationTest {

  @LocalServerPort private int port;

  @Test
  void websocketReceivesMessage() {
    try (Playwright playwright = Playwright.create()) {
      Browser browser = playwright.chromium().launch();
      try {
        Page page = browser.newPage();
        page.navigate("about:blank");

        page.evaluate(
            "(port) => {"
                + "  window.__wsMessages = [];"
                + "  const ws = new WebSocket('ws://localhost:' + port + '/slick');"
                + "  ws.onmessage = (e) => window.__wsMessages.push(e.data);"
                + "}",
            port);

        JSHandle handle =
            page.waitForFunction(
                "() => window.__wsMessages.length > 0 ? window.__wsMessages[0] : null",
                null,
                new Page.WaitForFunctionOptions().setTimeout(35000));

        String message = (String) handle.jsonValue();
        assertNotNull(message);
        assertFalse(message.isBlank());
      } finally {
        browser.close();
      }
    }
  }
}
