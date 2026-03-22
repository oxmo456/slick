package slick;

import java.util.Set;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

@Component
public class SlickWebSocketHandler extends TextWebSocketHandler {

    private static final Logger log = LoggerFactory.getLogger(SlickWebSocketHandler.class);

    private final K8sContext k8sContext;
    private final Set<WebSocketSession> sessions = ConcurrentHashMap.newKeySet();

    public SlickWebSocketHandler(K8sContext k8sContext) {
        super();
        this.k8sContext = k8sContext;
        log.info("YES");
    }

    @Override
    public void afterConnectionEstablished(WebSocketSession session) {
        log.info("WebSocket connection established: {} from {}", session.getId(), session.getRemoteAddress());
        sessions.add(session);
    }

    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        log.info("WebSocket connection closed: {} from {}", session.getId(), session.getRemoteAddress());
        log.info(status.toString());


        sessions.remove(session);
    }

    @Scheduled(fixedRate = 5000)
    public void pushRandomString() {
        String message = "pod_UUID: " + k8sContext.getPodUid() + "\nrand:" + UUID.randomUUID();
        sessions.removeIf(session -> {
            if (!session.isOpen()) return true;
            try {
                session.sendMessage(new TextMessage(message));
                return false;
            } catch (Exception e) {
                return true;
            }
        });
    }
}
