import { ComponentFixture, TestBed } from '@angular/core/testing';

import { MainTollbarComponent } from './main-tollbar.component';

describe('MainTollbarComponent', () => {
  let component: MainTollbarComponent;
  let fixture: ComponentFixture<MainTollbarComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [MainTollbarComponent]
    });
    fixture = TestBed.createComponent(MainTollbarComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
