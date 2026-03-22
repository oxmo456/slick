import {Component} from '@angular/core';
import {takeUntilDestroyed} from '@angular/core/rxjs-interop';
import {webSocket, WebSocketSubject} from 'rxjs/webSocket';

@Component({
    selector: 'root',
    standalone: true,
    styleUrl: './root.component.scss',
    templateUrl: './root.component.html',
    imports: [],
})
export class RootComponent {
    private socket: WebSocketSubject<string>;

    constructor() {
        this.socket = webSocket<string>({
            url: 'ws://localhost:5050/slick',
            deserializer: ({data}) => data,
        });

        this.socket.pipe(takeUntilDestroyed()).subscribe({
            next: (msg) => console.log('[Slick WS]', msg),
            error: (err) => console.error('[Slick WS] error', err),
            complete: () => console.log('[Slick WS] disconnected'),
        });
    }
}
