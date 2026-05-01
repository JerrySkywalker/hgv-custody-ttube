# Research Intent

## Dissertation Object

The dissertation studies trajectory tube modeling and space-based sensing resource inverse design for continuous custody of non-cooperative HGV targets.

The core question is not only whether a target can be observed at isolated moments, but whether the sensing constellation and scheduling policy can preserve mission-useful custody over time, under difficult windows and dynamic resource limits.

## Trajectory Tube

The trajectory tube represents HGV target motion as reusable, analyzable trajectory families. It should include nominal entries, heading perturbations, and critical geometries. The new code should make the trajectory data contract explicit so visibility, estimation, metrics, scheduling, STK comparison, and C++ export can consume the same trajectory representation.

## Continuous Custody

Continuous custody measures whether the system keeps enough task-relevant sensing support through time. It is stricter than simple coverage or average performance because short severe gaps may break downstream tracking and decision loops.

## Worst Window

Worst-window analysis asks where the sensing geometry is weakest over a sliding time interval. It supports inverse design by converting a long time series into robust requirements: the constellation must survive the most adverse interval, not only the average interval.

## Observability Bubble

An observability bubble is a local degradation region in support, geometry, or requirement margin. It is useful because it connects sensing resource choices with the future risk of losing custody. Chapter 5 scheduling should treat bubble formation and repair as primary operational signals.

## Chapter 4 Intent

Chapter 4 is the static inverse design layer. It asks which Walker constellation parameters and sensing assumptions satisfy robust static requirements over trajectory families and worst windows. The key outputs include feasible domains, minimum constellation boundaries, and D-series metrics such as DG, DA, DT, ClosedD, and OpenD.

## Chapter 5 Intent

Chapter 5 is the dynamic inversion and scheduling layer. It studies how sensing resources should be selected or switched over time to preserve custody. It compares static hold, greedy tracking, bubble-oriented policies, and dual-loop policies using tracking, covariance, custody, and bubble indicators.

## Why Average RMSE Is Not Enough

Average RMSE can hide mission-breaking intervals. A policy with attractive mean RMSE may still suffer worst-window collapse, long outage, or bubble growth. Bubble, custody, worst-window, pass ratio, and SC/DC/LoC occupancy are closer to the actual continuous-custody task because they measure persistence, robustness, and failure modes.

## Why The New Code Must Serve STK And C++

MATLAB remains the research mother implementation. STK is needed for high-fidelity scenario, object, and geometry verification. C++/MEX is the future deployment outlet for core computation. The new architecture must therefore keep the core mathematical kernels portable, deterministic, and free of plotting, COM, cache, and file IO.
