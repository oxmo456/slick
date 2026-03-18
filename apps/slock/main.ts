import './style.scss';
import {provideZonelessChangeDetection} from '@angular/core';
import {bootstrapApplication} from '@angular/platform-browser';
import {provideHttpClient} from '@angular/common/http';
import {RootComponent} from './root/root.component';

bootstrapApplication(RootComponent, {
    providers: [provideZonelessChangeDetection(), provideHttpClient()],
}).then(() => {
    console.log('yo!');
});
