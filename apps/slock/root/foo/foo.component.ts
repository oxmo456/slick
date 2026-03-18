import {Component, input} from '@angular/core';

@Component({
    selector: 'vctr-foo',
    templateUrl: './foo.component.html',
    styleUrls: ['./foo.component.scss'],
    standalone: true,
})
export class FooComponent {
    name = input('no name');

    message: string = 'Hello from the Foo Component!';
}
