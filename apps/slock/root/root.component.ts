import {Component} from '@angular/core';
import {takeUntilDestroyed} from '@angular/core/rxjs-interop';
import {retry, timer} from 'rxjs';
import {webSocket, WebSocketSubject} from 'rxjs/webSocket';
import {FooComponent} from './foo';

@Component({
    selector: 'root',
    standalone: true,
    styleUrl: './root.component.scss',
    templateUrl: './root.component.html',
    imports: [FooComponent]
})
export class RootComponent {
    private socket: WebSocketSubject<string>;

    constructor() {
        this.socket = webSocket<string>({
            url: 'ws://localhost:5050/slick',
            deserializer: ({data}) => data
        });

        this.socket
            .pipe(
                retry({
                    delay: (_, retryCount) => {
                        console.log(`[Slick WS] reconnecting in 5s (attempt ${retryCount})`);
                        return timer(5_000);
                    }
                }),
                takeUntilDestroyed()
            )
            .subscribe({
                next: (msg) => console.log('[Slick WS]', msg),
                error: (err) => console.error('[Slick WS] error', err),
                complete: () => console.log('[Slick WS] disconnected')
            });
    }
}
