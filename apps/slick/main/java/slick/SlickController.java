package slick;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SlickController {

    @RequestMapping("/")
    public String index() {
        return "Greetings from Slick!";
    }
}