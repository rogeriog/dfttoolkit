#!/usr/bin/env python3
"""
supercell_builder.py

Generate a Γ-only supercell for reciprocal-space convergence using ASE.

This script implements three schemes:

  Scheme A (Δk-target):
    N_i = ceil(|b_i| / Δk)

  Scheme B (M-points):
    N_i = ceil(M * |b_i| / B_max)

  Scheme C (kpra):
    Choose a target k-points per reciprocal atom (kpra).  We derive an
    equivalent “M” from
        M ≃ [ (kpra · N_atoms) · B_max³ / (|b₁||b₂||b₃| ) ]^(1/3)
    then use Scheme B with that M.

Here |b_i| are the lengths of the reciprocal lattice vectors of the unit cell.

Functions
---------
  get_reciprocal_lengths(atoms)
      Compute magnitudes of the reciprocal lattice vectors.
  calculate_supercell_dimensions(atoms, delta_k=None, M=None, kpra=None)
      Compute N1, N2, N3 from exactly one of Δk, M, or kpra.
  build_supercell(atoms, dimensions)
      Repeat the unit cell to form the supercell.

Usage
-----
  # Δk-target in Å⁻¹
  python supercell_builder.py -i POSCAR --delta_k 0.10 -o super_POSCAR

  # M-points along B_max
  python supercell_builder.py -i structure.cif --M 12 -o super.cif

  # kpra = 1000 k-points per reciprocal atom
  python supercell_builder.py -i unitcell.xyz --kpra 1000 -o supercell.xyz
"""

import numpy as np
from math import ceil
from ase import Atoms
from ase.io import read, write


def get_reciprocal_lengths(atoms: Atoms) -> np.ndarray:
    """
    Compute the magnitudes of the three reciprocal lattice vectors.

    Parameters
    ----------
    atoms : ase.Atoms
        Periodic Atoms object with a defined cell.

    Returns
    -------
    numpy.ndarray
        [|b1|, |b2|, |b3|] in Å⁻¹.
    """
    a1, a2, a3 = atoms.get_cell()
    V = np.dot(a1, np.cross(a2, a3))
    b1 = 2 * np.pi * np.cross(a2, a3) / V
    b2 = 2 * np.pi * np.cross(a3, a1) / V
    b3 = 2 * np.pi * np.cross(a1, a2) / V
    return np.array([np.linalg.norm(b1),
                     np.linalg.norm(b2),
                     np.linalg.norm(b3)])


def calculate_supercell_dimensions(atoms: Atoms,
                                   delta_k: float = None,
                                   M: int = None,
                                   kpra: float = None
                                   ) -> tuple[int, int, int]:
    """
    Determine supercell replication factors (N1, N2, N3).

    Exactly one of delta_k, M, or kpra must be provided.

    Scheme A (Δk-target):
      N_i = ceil(|b_i| / delta_k)

    Scheme B (M-points):
      B_max = max_i |b_i|
      N_i = ceil(M * |b_i| / B_max)

    Scheme C (kpra):
      Let N_atoms = number of atoms in the unit cell.
      Compute
        M_est = [ (kpra * N_atoms) * B_max^3 / (|b1||b2||b3|) ]^(1/3)
      Round up M = ceil(M_est), then apply Scheme B.

    Parameters
    ----------
    atoms : ase.Atoms
        Unit cell.
    delta_k : float, optional
        Target k-spacing (Å⁻¹).
    M : int, optional
        Points along the largest reciprocal vector.
    kpra : float, optional
        Target k-points per reciprocal atom.

    Returns
    -------
    (N1, N2, N3) : tuple of int
        Replication factors along a1, a2, a3.
    """
    B = get_reciprocal_lengths(atoms)
    choices = [delta_k is not None, M is not None, kpra is not None]
    if sum(choices) != 1:
        raise ValueError("Specify exactly one of --delta_k, --M, or --kpra")

    if delta_k is not None:
        # Scheme A
        return tuple(ceil(B_i / delta_k) for B_i in B)

    Bmax = B.max()

    if kpra is not None:
        # Scheme C: derive M from kpra
        n_atoms = len(atoms)
        Bprod = B[0] * B[1] * B[2]
        M_est = ((kpra * n_atoms) * (Bmax**3) / Bprod) ** (1/3)
        M = ceil(M_est)
        print(f"[kpra → estimated M]  M_est = {M_est:.3f} → using M = {M}")

    # Scheme B (or derived via kpra)
    return tuple(ceil(M * B_i / Bmax) for B_i in B)


def build_supercell(atoms: Atoms,
                    dimensions: tuple[int, int, int]) -> Atoms:
    """
    Build the supercell by repeating the unit cell.

    Parameters
    ----------
    atoms : ase.Atoms
        Unit cell.
    dimensions : (N1, N2, N3)
        Replication factors.

    Returns
    -------
    ase.Atoms
        The supercell.
    """
    return atoms.repeat(dimensions)


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description="Generate a Γ-only supercell for reciprocal-space convergence."
    )
    parser.add_argument(
        "-i", "--input",
        required=True,
        help="Input structure file (POSCAR, CIF, XYZ, …)."
    )
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument("--delta_k", type=float,
                       help="Target k-spacing (Å⁻¹).")
    group.add_argument("--M", type=int,
                       help="Points along the largest reciprocal vector.")
    group.add_argument("--kpra", type=float,
                       help="k-points per reciprocal atom (e.g. 1000).")
    parser.add_argument(
        "-o", "--output",
        required=True,
        help="Output file for the supercell."
    )

    args = parser.parse_args()

    atoms = read(args.input, parallel=False)
    N1, N2, N3 = calculate_supercell_dimensions(
        atoms,
        delta_k=args.delta_k,
        M=args.M,
        kpra=args.kpra
    )

    # Loud and clear output of the supercell repetitions
    print("\n" + "*" * 60)
    print(">>>>> SUPER​​CELL REPETITION FACTORS <<<<<")
    print(f"   a1 direction replications (N1): {N1}")
    print(f"   a2 direction replications (N2): {N2}")
    print(f"   a3 direction replications (N3): {N3}")
    print("*" * 60 + "\n")

    supercell = build_supercell(atoms, (N1, N2, N3))
    write(args.output, supercell)
    print(f"Supercell written to {args.output}")

if __name__ == "__main__":
    main()
