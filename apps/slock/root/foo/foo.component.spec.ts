import {TestBed} from '@angular/core/testing';
import {beforeEach, describe, expect, it} from 'vitest';
import {FooComponent} from './foo.component';

describe('FooComponent', () => {
    beforeEach(async () => {
        await TestBed.configureTestingModule({
            imports: [FooComponent]
        }).compileComponents();
    });

    it('renders the default name', () => {
        const fixture = TestBed.createComponent(FooComponent);
        fixture.detectChanges();
        const element = fixture.nativeElement.querySelector('.block div:first-child');
        expect(element.textContent).toContain('no name');
    });
});
