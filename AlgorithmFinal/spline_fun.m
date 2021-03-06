function [r_0, a, p_s, parameters] = spline_fun(pm_num, gm_num, pt_num, Gt_num, k_num)
                            % Analytical part
                            syms r(p) A B C D gm Gt pm pt k

                            S = solve( A + B*pm + C*pm^2 + D*pm^3 == gm, B+ 2*C*pm + 3*D*pm^2 == k, A + B*pt + C*pt^2 + D*pt^3 == Gt, 2*C+6*D*pt == 0, A, B, C, D);
                            r_ekv = S.A + S.B*p + S.C* p ^2 + S.D* p ^3;
                            diff_r = diff(simplify(r_ekv),p);
                            r_final_sym = subs(simplify(diff_r),p,pt);

                            % Insert the numerical values,
                            slope_spline =  double( subs(subs(subs(subs(subs(simplify(r_final_sym), k, k_num),Gt,Gt_num),pt ,pt_num), pm, pm_num), gm, gm_num));
                            
                            % Save the functional values..

                            r_0 = Gt_num - slope_spline * pt_num;
                            a = slope_spline;
                            p_s = pt_num - Gt_num/slope_spline;

                            % Saving the spline- functional form
                            A_num = double( subs(subs(subs(subs(subs(S.A, k,k_num),Gt,Gt_num),pt,pt_num),pm,pm_num),gm,gm_num));
                            B_num = double( subs(subs(subs(subs(subs(S.B, k,k_num),Gt,Gt_num),pt,pt_num),pm,pm_num),gm,gm_num));
                            C_num = double( subs(subs(subs(subs(subs(S.C, k,k_num),Gt,Gt_num),pt,pt_num),pm,pm_num),gm,gm_num));
                            D_num = double( subs(subs(subs(subs(subs(S.D, k,k_num),Gt,Gt_num),pt,pt_num),pm,pm_num),gm,gm_num));
                            parameters = [A_num B_num C_num D_num];
end
