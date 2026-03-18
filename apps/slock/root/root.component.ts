import {Component, inject, OnDestroy, OnInit} from '@angular/core';
import {HttpClient} from '@angular/common/http';
import {interval, Subscription, switchMap} from 'rxjs';

@Component({
    selector: 'root',
    standalone: true,
    styleUrl: './root.component.scss',
    templateUrl: './root.component.html',
    imports: [],
})
export class RootComponent implements OnInit, OnDestroy {
    private http = inject(HttpClient);
    private subscription: Subscription | undefined;

    constructor() {
        console.log('w00t!');
    }

    ngOnInit() {
        this.subscription = interval(2000)
            .pipe(switchMap(() => this.http.get('http://localhost:9000/', {responseType: 'text'})))
            .subscribe({
                next: (response) => console.log('[Slick API]', response),
                error: (err) => console.error('[Slick API] Error:', err),
            });
    }

    ngOnDestroy() {
        this.subscription?.unsubscribe();
    }
}
